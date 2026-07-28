---
name: notify
description: Send an ntfy push notification. Usage: /notify <message> [title] [priority]. Priority: max, high, default, low, min. Reads config from ~/.config/claude/ntfy.env. Use after long-running tasks complete.
---

Send a push notification via the ntfy server. The config file is `~/.config/claude/ntfy.env`.

Arguments (all positional, all optional except message):
- **message** — notification body
- **title** — notification title (default: "Claude Code")
- **priority** — one of `max`, `high`, `default`, `low`, `min` (default: `default`)

First check that the config file exists:
```bash
test -f ~/.config/claude/ntfy.env || echo "MISSING_CONFIG"
```

If the output is `MISSING_CONFIG`, tell the user:
> Config file `~/.config/claude/ntfy.env` not found. Run `~/.config/claude/setup-claude-ntfy.sh` to create it.

Otherwise, send the notification by substituting the user's arguments into the curl command:

```bash
source ~/.config/claude/ntfy.env && curl -s \
  -H "Authorization: Bearer $NTFY_TOKEN" \
  -H "Title: $TITLE" \
  -H "Priority: $PRIORITY" \
  -d "$MESSAGE" \
  "$NTFY_URL/$NTFY_TOPIC"
```

- Replace `$MESSAGE` with the message argument.
- Replace `$TITLE` with the title argument, or `Claude Code` if not provided.
- Replace `$PRIORITY` with the priority argument, or `default` if not provided. If the user supplies an invalid priority value, default to `default`.

Report success or failure based on the curl exit code.
