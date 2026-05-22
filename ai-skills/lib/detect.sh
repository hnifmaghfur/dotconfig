#!/bin/bash

# AI Agent Detection Library
# Returns 0 if agent is detected, 1 otherwise

detect_claude() {
  command -v claude >/dev/null 2>&1 && [ -d "$HOME/.claude" ]
}

detect_opencode() {
  command -v opencode >/dev/null 2>&1 && [ -d "$HOME/.config/opencode" ]
}

detect_codex() {
  command -v codex >/dev/null 2>&1 && [ -d "$HOME/.codex" ]
}

detect_gemini() {
  command -v gemini >/dev/null 2>&1 && [ -d "$HOME/.config/gemini" ]
}

detect_cursor() {
  command -v cursor >/dev/null 2>&1 && [ -d "$HOME/.cursor" ]
}

detect_windsurf() {
  command -v windsurf >/dev/null 2>&1
}

detect_aider() {
  command -v aider >/dev/null 2>&1 && [ -d "$HOME/.aider" ]
}

detect_cline() {
  command -v cline >/dev/null 2>&1 || command -v roo >/dev/null 2>&1
}

detect_hermes() {
  command -v hermes >/dev/null 2>&1 && [ -d "$HOME/.hermes" ]
}

detect_kilo() {
  command -v kilo >/dev/null 2>&1 && [ -d "$HOME/.kilocode" ]
}

# Copilot CLI may not have a standard config dir; fall back to command check only
detect_copilot() {
  command -v copilot >/dev/null 2>&1
}

# Detect all agents and print a space-separated list of detected agent names
detect_all_agents() {
  local agents=""
  detect_claude && agents="${agents}claude "
  detect_opencode && agents="${agents}opencode "
  detect_codex && agents="${agents}codex "
  detect_gemini && agents="${agents}gemini "
  detect_cursor && agents="${agents}cursor "
  detect_windsurf && agents="${agents}windsurf "
  detect_aider && agents="${agents}aider "
  detect_cline && agents="${agents}cline "
  detect_hermes && agents="${agents}hermes "
  detect_kilo && agents="${agents}kilo "
  detect_copilot && agents="${agents}copilot "
  echo "${agents% }"
}
