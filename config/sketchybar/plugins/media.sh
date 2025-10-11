#!/bin/bash

# As of macos 26, the built-in events in media events don't work.
# Until that's fixed, we'll use snd-ctl to poll the current media state.
MEDIA_INFO=$(snd-ctl info --json 2>/dev/null)
IS_PLAYING="$(echo $MEDIA_INFO | jq -r '.is_playing')"
CURRENT_SONG="$(echo $MEDIA_INFO | jq -r '.title + "-" + .artist')"

if [ "$IS_PLAYING" = "true" ]; then
	ICON=
else
	ICON=
fi
sketchybar --set $NAME label="$CURRENT_SONG" icon="$ICON" drawing=on
