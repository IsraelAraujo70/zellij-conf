# Start Zellij only for a top-level interactive terminal shell.
# Set ZELLIJ_AUTO_START=false to open a plain shell instead.
case $- in
  *i*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

if [[ "${ZELLIJ_AUTO_START:-true}" == "true" \
  && -t 0 \
  && -t 1 \
  && -z "${ZELLIJ:-}" \
  && -z "${TMUX:-}" \
  && "${TERM:-}" != "dumb" ]] \
  && command -v zellij >/dev/null 2>&1; then
  exec zellij
fi
