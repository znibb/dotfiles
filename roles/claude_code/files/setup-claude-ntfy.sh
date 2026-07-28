#!/usr/bin/env bash
# Sets up ntfy notification credentials for the Claude Code /notify skill.
# Writes to ~/.config/claude/ntfy.env (outside any git repo).

set -euo pipefail

CONFIG_FILE="$HOME/.config/claude/ntfy.env"
FORCE=false

for arg in "$@"; do
  [[ "$arg" == "-f" ]] && FORCE=true
done

if [[ -f "$CONFIG_FILE" ]] && [[ "$FORCE" == false ]]; then
  echo "$CONFIG_FILE already exists. Run with -f to overwrite."
  exit 0
fi

echo "ntfy notification setup for Claude Code /notify skill"
echo "Config will be written to: $CONFIG_FILE"
echo ""

read -rp "ntfy server URL (e.g. https://ntfy.example.com): " NTFY_URL
NTFY_URL="${NTFY_URL%/}"  # strip trailing slash

read -rp "Topic: " NTFY_TOPIC

read -rsp "Access token (input hidden): " NTFY_TOKEN
echo ""

cat > "$CONFIG_FILE" <<EOF
NTFY_URL=$NTFY_URL
NTFY_TOPIC=$NTFY_TOPIC
NTFY_TOKEN=$NTFY_TOKEN
EOF

chmod 600 "$CONFIG_FILE"

echo ""
echo "Config written to $CONFIG_FILE (mode 600)"
echo ""
echo "Test with:"
echo "  source $CONFIG_FILE && curl -H \"Authorization: Bearer \$NTFY_TOKEN\" -d \"test\" \"\$NTFY_URL/\$NTFY_TOPIC\""
