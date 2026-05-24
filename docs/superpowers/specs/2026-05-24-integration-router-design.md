# Spec: integration-router — Auto-Activation GStack × GSD × Superpower

**Tanggal:** 2026-05-24
**Status:** Approved (user-confirmed)
**Author:** Claude (via brainstorming session)

## Problem

User sudah mendokumentasikan integrasi 3 sistem (GStack, GSD, Superpower) di `ai-skills/SKILL.md`, tapi belum ada mekanisme yang membuat integrasi tersebut **auto-aktif** — analog dengan:
- `superpowers:brainstorming` yang auto-invoke saat user mulai kerja kreatif
- RTK yang auto-rewrite tiap command `ls`/`git` via hook

Tanpa auto-activation, user harus ingat manual urutan `/gsd-plan-phase → superpowers:subagent-driven-development → /qa → /ship` — gampang ke-skip.

## Goal

Setelah satu kali bootstrap (`./ai-skills/install-integration.sh`), tiap session AI agent otomatis dipandu mengikuti workflow integrasi tanpa user perlu mengingat tiap step.

## Non-Goal

- **Tidak** memaksa workflow — user tetap bisa override/skip
- **Tidak** menulis ulang skill GSD/GStack/Superpower yang sudah ada — hanya membuat router
- **Tidak** menambahkan dependency runtime baru (cukup bash + jq yang sudah ada)

## Architecture — 3 Lapisan

### Lapisan 1 — `integration-router` SKILL (cross-agent)

**File:** `ai-skills/skills/integration-router/SKILL.md`

Skill markdown agent-agnostic (kompatibel Claude Code, Gemini, OpenCode, Codex, Cursor). YAML frontmatter dengan `description` yang sangat trigger-friendly:

> "Use whenever user starts development work (build, implement, fix, ship, deploy, refactor) — orchestrates GSD planning → Superpower execution → GStack quality gates"

Isi skill:
- Routing matrix lengkap (intent → command)
- Phase Gate pattern wajib
- Anti-patterns
- Instruksi escalation ke gsd-plan-phase / subagent-driven-development / qa-review-ship

Mekanisme aktivasi:
- **Claude Code**: model auto-invoke via Skill tool (sama persis brainstorming)
- **Gemini/OpenCode/Codex/Cursor**: file di-reference dari `AGENTS.md` / `GEMINI.md` / `CLAUDE.md` project root → di-load tiap session start

### Lapisan 2 — Hook `UserPromptSubmit` (Claude Code only, RTK-style)

**File:** `~/.claude/hooks/integration-router-hook.sh`

Hook deterministik yang dipanggil setiap user submit prompt. Logic:
1. Baca JSON dari stdin → ambil `prompt`
2. Skip jika prompt kosong, atau sudah ada keyword `gsd-`/`gstack`/`superpower`/`integration-router` (avoid double-trigger)
3. Scan prompt untuk pola intent (regex multi-bahasa ID+EN):
   - Plan/build: `buat|bikin|implementasi|build|implement|create.*feature|add.*feature`
   - Fix/debug: `fix|perbaiki|debug|bug`
   - Ship/deploy: `ship|deploy|release|rilis|merge`
4. Jika match → output ke stdout teks hint pendek:
   ```
   [integration-router] Dev intent terdeteksi → recommended flow:
   plan: /gsd-plan-phase  •  execute: superpowers:subagent-driven-development  •  verify: /qa /review  •  ship: /ship
   ```
5. Always `exit 0` (jangan block).

Output stdout dari `UserPromptSubmit` hook di-inject sebagai additional context ke prompt model. Effect: tiap prompt yang match intent, model dapat reminder otomatis.

### Lapisan 3 — Bootstrap Installer

**File:** `ai-skills/install-integration.sh`

Single command (`bash ai-skills/install-integration.sh`) yang:
1. Detect agent (reuse logic dari SKILL.md)
2. Fix gstack PATH di `~/.zshrc` jika belum ada (`~/.claude/skills/gstack/bin`)
3. Untuk Claude Code:
   - Copy `ai-skills/skills/integration-router/SKILL.md` ke `~/.claude/skills/integration-router/SKILL.md`
   - Copy hook script ke `~/.claude/hooks/integration-router-hook.sh` (chmod +x)
   - Merge `UserPromptSubmit` hook entry ke `~/.claude/settings.json` (pakai `jq`, preserve existing hooks)
4. Untuk agent lain: append `@<repo>/ai-skills/skills/integration-router/SKILL.md` ke `AGENTS.md` (atau `GEMINI.md`) project root
5. Idempotent — bisa dijalankan berulang tanpa duplikasi
6. Tampilkan summary akhir

## Trade-off Honest

| Lapisan | Reliability | Coverage |
|---------|-------------|----------|
| 1 (skill desc) | Model judgment — bisa miss | Cross-agent |
| 2 (hook) | 100% deterministik | Claude Code only |
| 3 (installer) | Idempotent | All agents |

Tidak ada cara cross-agent untuk literal "rewrite tiap prompt" — itu butuh hook yang Claude-specific. Yang ada cuma session-start config (AGENTS.md) + skill matching.

## File Inventory

Yang dibuat baru:
- `ai-skills/skills/integration-router/SKILL.md`
- `ai-skills/install-integration.sh`
- `ai-skills/hooks/integration-router-hook.sh` (source-of-truth; installer copy ke ~/.claude/hooks/)
- `AGENTS.md` (root dotconfig) — apply ke repo ini
- `docs/superpowers/specs/2026-05-24-integration-router-design.md` (file ini)

Yang dimodifikasi:
- `ai-skills/SKILL.md` — tambah section "Auto-activation"
- `~/.zshrc` — append PATH
- `~/.claude/settings.json` — append UserPromptSubmit hook entry
- `~/.claude/skills/integration-router/SKILL.md` — di-copy oleh installer

## Verification

Setelah implementasi:
1. `bash ai-skills/install-integration.sh` di repo dotconfig → exit 0
2. `cat ~/.claude/settings.json | jq '.hooks.UserPromptSubmit'` → entry baru ada
3. `ls ~/.claude/skills/integration-router/SKILL.md` → file ada
4. `which gstack-config` (setelah `source ~/.zshrc`) → resolved
5. Restart Claude session → hook aktif (prompt "fix bug X" dapat hint)

## Rollback

Jika butuh uninstall:
- Hapus `~/.claude/skills/integration-router/`
- Hapus `~/.claude/hooks/integration-router-hook.sh`
- Edit `~/.claude/settings.json` — hapus `UserPromptSubmit` entry untuk hook ini
- Hapus PATH line di `~/.zshrc`

(Installer phase 2 bisa tambah flag `--uninstall` di iterasi berikutnya.)
