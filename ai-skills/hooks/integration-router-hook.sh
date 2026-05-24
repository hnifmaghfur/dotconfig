#!/usr/bin/env bash
# integration-router UserPromptSubmit hook
# ----------------------------------------------------------------------------
# Reads JSON from stdin, detects development-workflow intents in the user's
# prompt, and injects a short routing hint via stdout so the model is reminded
# to consult the integration-router skill.
#
# Always exit 0 (never block). Output to stdout is merged into prompt context
# by Claude Code UserPromptSubmit hook contract.
# ----------------------------------------------------------------------------

set -u

# --- read prompt -------------------------------------------------------------
INPUT="$(cat 2>/dev/null || true)"
[ -z "$INPUT" ] && exit 0

# Extract prompt (require jq; if missing, fall back to grep)
if command -v jq >/dev/null 2>&1; then
  PROMPT="$(printf '%s' "$INPUT" | jq -r '.prompt // .user_message // ""' 2>/dev/null || echo '')"
else
  PROMPT="$INPUT"
fi
[ -z "$PROMPT" ] && exit 0

# --- short-circuit: avoid double-trigger -------------------------------------
# If user already mentions integration tooling, no need to remind.
case "$PROMPT" in
  *integration-router*|*gsd-*|*gstack*|*superpower*|*"/qa"*|*"/ship"*|*"/review"*) exit 0 ;;
esac

# --- intent detection --------------------------------------------------------
# Indonesian + English keywords. Tuned to be specific enough to avoid noise.
PLAN_RE='\b(buat fitur|bikin fitur|implementasi|tambah fitur|build feature|implement feature|create feature|add feature|new feature|build a|implement a|create a feature)\b'
FIX_RE='\b(fix bug|perbaiki bug|debug|investigate bug|fix the bug|squash bug|bug fix)\b'
SHIP_RE='\b(ship it|deploy|rilis|release ke prod|merge pr|create pr|raise pr|land and deploy|push to prod)\b'
REFACTOR_RE='\b(refactor|cleanup|simplify code|restructure)\b'
PLAN_QUERY_RE='\b(plan ini|buat plan|create plan|planning|roadmap)\b'

LANE=""
shopt -s nocasematch 2>/dev/null || true
if [[ "$PROMPT" =~ $PLAN_RE ]]; then LANE="NEW_WORK"
elif [[ "$PROMPT" =~ $FIX_RE ]]; then LANE="DEBUG"
elif [[ "$PROMPT" =~ $SHIP_RE ]]; then LANE="SHIP"
elif [[ "$PROMPT" =~ $REFACTOR_RE ]]; then LANE="REFACTOR"
elif [[ "$PROMPT" =~ $PLAN_QUERY_RE ]]; then LANE="PLANNING"
fi
shopt -u nocasematch 2>/dev/null || true

[ -z "$LANE" ] && exit 0

# --- emit hint ---------------------------------------------------------------
case "$LANE" in
  NEW_WORK)
    cat <<'EOF'
[integration-router] Dev intent terdeteksi (NEW_WORK). Recommended flow:
  1) PLAN     → /gsd-plan-phase  (or /gsd-new-project if no ROADMAP.md, or /gsd-quick for small tasks)
  2) EXECUTE  → superpowers:subagent-driven-development
  3) VERIFY   → /qa  •  /review  •  /gsd-verify-work
  4) SHIP     → /ship  →  /context-save
Consult integration-router skill for full routing matrix before answering.
EOF
    ;;
  DEBUG)
    cat <<'EOF'
[integration-router] Dev intent terdeteksi (DEBUG). Recommended flow:
  1) superpowers:systematic-debugging  (root-cause first, no shortcut fixes)
  2) /qa  to reproduce & verify fix
  3) /review on the diff before merging
EOF
    ;;
  SHIP)
    cat <<'EOF'
[integration-router] Dev intent terdeteksi (SHIP). Pre-flight gates wajib:
  [ ] /qa lulus           [ ] /review lulus           [ ] /gsd-verify-work OK
Lalu: /ship  →  /land-and-deploy  →  /context-save
EOF
    ;;
  REFACTOR)
    cat <<'EOF'
[integration-router] Dev intent terdeteksi (REFACTOR). Recommended flow:
  1) /gsd-plan-phase  (refactor scope harus dibatasi via PLAN.md)
  2) superpowers:test-driven-development  (test dulu, lalu refactor)
  3) /review  before merge
EOF
    ;;
  PLANNING)
    cat <<'EOF'
[integration-router] Planning intent terdeteksi. Use:
  /gsd-plan-phase  (existing project)  •  /gsd-new-project  (fresh init)  •  /autoplan  (multi-perspective)
EOF
    ;;
esac

exit 0
