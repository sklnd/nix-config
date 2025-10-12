#!/bin/bash

if [ "$1" = "$FOCUSED" ]; then
    sketchybar --set $NAME \
      background.color=0xffc29df1 \
      label.color=0xff24273a
else
    sketchybar --set $NAME \
      background.color=0xff123456 \
      label.color=0xffffffff
fi
