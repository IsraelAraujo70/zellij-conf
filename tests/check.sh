#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

command -v zellij >/dev/null 2>&1 || {
  echo "zellij is required" >&2
  exit 1
}
command -v zsh >/dev/null 2>&1 || {
  echo "zsh is required" >&2
  exit 1
}

bash -n "$repo/shell/auto-start.sh"
zsh -n "$repo/shell/auto-start.sh"

check_output="$(ZELLIJ_CONFIG_DIR="$repo" zellij setup --check 2>&1)"
grep -F '[CONFIG FILE]: Well defined.' <<<"$check_output" >/dev/null

for layout in "$repo"/layouts/*.kdl; do
  name="$(basename "$layout" .kdl)"
  ZELLIJ_CONFIG_DIR="$repo" zellij setup --dump-layout "$name" >/dev/null
done

echo "Zellij config, layouts, and shell integration are valid."
