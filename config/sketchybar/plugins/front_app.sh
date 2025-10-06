#!/usr/bin/env zsh

ICON_PADDING_RIGHT=5

case $INFO in
"Code")
    ICON_PADDING_RIGHT=4
    ICON=󰨞
    ;;
"Finder")
    ICON=󰀶
    ;;
"Google Chrome")
    ICON_PADDING_RIGHT=7
    ICON=
    ;;
"Preview")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
*)
    ICON_PADDING_RIGHT=2
    ICON=
    ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT
sketchybar --set $NAME.name label="$INFO"
