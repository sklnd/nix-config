#!/bin/sh

if command -v tailscale >/dev/null 2>&1; then
    STATUS=$(tailscale status --json 2>/dev/null) || STATUS=""
else
    STATUS=$(/Applications/Tailscale.app/Contents/MacOS/Tailscale status --json 2>/dev/null) || STATUS=""
fi

LABEL="Tailscale unavailable"
COLOR=0xff8087a2
STATE=$(printf '%s\n' "$STATUS" | jq -r '.BackendState // empty' 2>/dev/null)

if [ "$STATE" = "Running" ]; then
    LABEL="Tailscale"
    COLOR=0xffa6da95
    EXIT_NODE=$(printf '%s\n' "$STATUS" | jq -r '.ExitNodeStatus.ID // empty')
    if [ -n "$EXIT_NODE" ]; then
        EXIT_NAME=$(printf '%s\n' "$STATUS" | jq -r --arg id "$EXIT_NODE" '
            first(.Peer[]? | select(.ID == $id) | .HostName | select(. != null and . != "")) // $id
        ')
        LABEL="Exit: $EXIT_NAME"
        COLOR=0xffc29df1
        if printf '%s\n' "$STATUS" | jq -e '.ExitNodeStatus.Online == false' >/dev/null; then
            LABEL="Exit offline: $EXIT_NAME"
            COLOR=0xffed8796
        fi
    fi
elif [ -n "$STATE" ]; then
    LABEL="Tailscale off"
fi

sketchybar --set "$NAME" label="$LABEL" icon=󰒃 icon.color="$COLOR"
