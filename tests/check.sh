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
command -v script >/dev/null 2>&1 || {
  echo "script is required" >&2
  exit 1
}

bash -n "$repo/shell/auto-start.sh"
zsh -n "$repo/shell/auto-start.sh"
grep -F 'CMUX_BUNDLE_ID' "$repo/shell/auto-start.sh" >/dev/null
grep -F 'CMUX_SHELL_INTEGRATION' "$repo/shell/auto-start.sh" >/dev/null

tmp="$(mktemp -d)"
trap 'rm -r "$tmp"' EXIT
cat >"$tmp/zellij" <<'EOF'
#!/bin/sh
echo ZELLIJ_LAUNCHED
EOF
chmod +x "$tmp/zellij"

cmux_output="$(
  env -u ZELLIJ -u TMUX \
    CMUX_BUNDLE_ID=com.cmuxterm.app \
    CMUX_SHELL_INTEGRATION=1 \
    ZELLIJ_AUTO_START=true \
    PATH="$tmp:$PATH" \
    TERM=xterm-256color \
    script -q /dev/null zsh -fic "source '$repo/shell/auto-start.sh'; echo PLAIN_SHELL"
)"
grep -F 'PLAIN_SHELL' <<<"$cmux_output" >/dev/null
if grep -F 'ZELLIJ_LAUNCHED' <<<"$cmux_output" >/dev/null; then
  echo "cmux terminal unexpectedly launched Zellij" >&2
  exit 1
fi

plain_output="$(
  env -u ZELLIJ -u TMUX -u CMUX_BUNDLE_ID -u CMUX_SHELL_INTEGRATION \
    ZELLIJ_AUTO_START=true \
    PATH="$tmp:$PATH" \
    TERM=xterm-256color \
    script -q /dev/null zsh -fic "source '$repo/shell/auto-start.sh'; echo PLAIN_SHELL"
)"
grep -F 'ZELLIJ_LAUNCHED' <<<"$plain_output" >/dev/null

check_output="$(ZELLIJ_CONFIG_DIR="$repo" zellij setup --check 2>&1)"
grep -F '[CONFIG FILE]: Well defined.' <<<"$check_output" >/dev/null

for layout in "$repo"/layouts/*.kdl; do
  name="$(basename "$layout" .kdl)"
  ZELLIJ_CONFIG_DIR="$repo" zellij setup --dump-layout "$name" >/dev/null
done

echo "Zellij config, layouts, and shell integration are valid."
