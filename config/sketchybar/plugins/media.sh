#!/bin/bash

# As of macos 26, the built-in events in media events don't work.
# Until that's fixed, we'll use snd-ctl to poll the current media state.
MEDIA_INFO=$(snd-ctl info --json 2>/dev/null)
IS_PLAYING="$(printf '%s\n' "$MEDIA_INFO" | jq -r '.is_playing')"
if [ "$IS_PLAYING" != "true" ]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

CURRENT_SONG="$(printf '%s\n' "$MEDIA_INFO" | jq -r '[.title, .artist] | map(select(. != null and . != "")) | join(" · ")')"
sketchybar --set "$NAME" label="$CURRENT_SONG" icon= drawing=on
