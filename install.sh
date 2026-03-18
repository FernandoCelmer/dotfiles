#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# Marketplace installer
# Usage:
#   ./install.sh skill <name>
#   ./install.sh plugin <name>
# ─────────────────────────────────────────────

REPO_RAW="https://raw.githubusercontent.com/FernandoCelmer/dotfiles/master"
REGISTRY_URL="${REPO_RAW}/registry.json"
SKILLS_DIR="${HOME}/.claude/skills"
PLUGINS_DIR="${HOME}/.local/share/dotfiles-plugins"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()    { echo -e "${GREEN}[install]${NC} $*"; }
warn()   { echo -e "${YELLOW}[warn]${NC} $*"; }
error()  { echo -e "${RED}[error]${NC} $*" >&2; exit 1; }

require() {
  command -v "$1" &>/dev/null || error "'$1' is required but not installed."
}

require curl
require jq

# ─────────────────────────────────────────────
# Fetch registry
# ─────────────────────────────────────────────
fetch_registry() {
  curl -fsSL "$REGISTRY_URL" 2>/dev/null || error "Could not fetch registry from ${REGISTRY_URL}"
}

# ─────────────────────────────────────────────
# Install a skill
# ─────────────────────────────────────────────
install_skill() {
  local name="$1"
  local registry
  registry=$(fetch_registry)

  local entry
  entry=$(echo "$registry" | jq -r --arg name "$name" '.skills[] | select(.name == $name)')

  [ -z "$entry" ] && error "Skill '${name}' not found in registry."

  local path version description
  path=$(echo "$entry" | jq -r '.path')
  version=$(echo "$entry" | jq -r '.version')
  description=$(echo "$entry" | jq -r '.description')

  log "Installing skill '${name}' v${version}"
  log "  ${description}"

  mkdir -p "$SKILLS_DIR"

  local dest="${SKILLS_DIR}/${name}.md"
  curl -fsSL "${REPO_RAW}/${path}" -o "$dest" || error "Failed to download skill file."

  log "Skill installed at ${dest}"
  log "Reload Claude Code to use: /${name}"
}

# ─────────────────────────────────────────────
# Install a plugin
# ─────────────────────────────────────────────
install_plugin() {
  local name="$1"
  local registry
  registry=$(fetch_registry)

  local entry
  entry=$(echo "$registry" | jq -r --arg name "$name" '.plugins[] | select(.name == $name)')

  [ -z "$entry" ] && error "Plugin '${name}' not found in registry."

  local path version description install_script
  path=$(echo "$entry" | jq -r '.path')
  version=$(echo "$entry" | jq -r '.version')
  description=$(echo "$entry" | jq -r '.description')
  install_script=$(echo "$entry" | jq -r '.install')

  log "Installing plugin '${name}' v${version}"
  log "  ${description}"

  local tmp_dir
  tmp_dir=$(mktemp -d)
  trap 'rm -rf "$tmp_dir"' EXIT

  local script_url="${REPO_RAW}/${install_script}"
  curl -fsSL "$script_url" -o "${tmp_dir}/install.sh" || error "Failed to download install script."
  chmod +x "${tmp_dir}/install.sh"

  log "Running install script..."
  bash "${tmp_dir}/install.sh"

  log "Plugin '${name}' installed successfully."
}

# ─────────────────────────────────────────────
# List available items
# ─────────────────────────────────────────────
list_items() {
  local registry
  registry=$(fetch_registry)

  echo ""
  echo "── Skills ──────────────────────────────────"
  echo "$registry" | jq -r '.skills[] | "  \(.name) v\(.version)  -  \(.description)"'

  echo ""
  echo "── Plugins ─────────────────────────────────"
  echo "$registry" | jq -r '.plugins[] | "  \(.name) v\(.version)  -  \(.description)"'
  echo ""
}

# ─────────────────────────────────────────────
# Entry point
# ─────────────────────────────────────────────
TYPE="${1:-}"
NAME="${2:-}"

case "$TYPE" in
  skill)
    [ -z "$NAME" ] && error "Usage: install.sh skill <name>"
    install_skill "$NAME"
    ;;
  plugin)
    [ -z "$NAME" ] && error "Usage: install.sh plugin <name>"
    install_plugin "$NAME"
    ;;
  list)
    list_items
    ;;
  *)
    echo "Usage:"
    echo "  ./install.sh skill <name>    Install a Claude Code skill"
    echo "  ./install.sh plugin <name>   Install a plugin"
    echo "  ./install.sh list            List all available skills and plugins"
    exit 1
    ;;
esac
