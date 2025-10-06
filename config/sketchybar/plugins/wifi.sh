#!/bin/sh

INFO="$(ipconfig getsummary $(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}') | awk -F ' SSID : ' '/ SSID : / {print $2}')"

if [ "$SENDER" = "wifi_change" ]; then
  WIFI=${INFO:-"Not Connected"}
  sketchybar --set $NAME label="${WIFI}" icon=""
fi
