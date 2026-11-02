#!/bin/sh

INTERFACE=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2; exit}')
if [ -z "$INTERFACE" ]; then
    INTERFACE=$(route -n get -inet6 default 2>/dev/null | awk '/interface:/ {print $2; exit}')
fi

PORT=$(networksetup -listallhardwareports | awk -v device="$INTERFACE" '
    /^Hardware Port: / {port = substr($0, 16)}
    $1 == "Device:" && $2 == device {print port; exit}
')

ICON=󰈀
case "$PORT" in
Wi-Fi | AirPort)
    ICON=
    # macOS may redact the SSID unless `sudo ipconfig setverbose 1` is enabled.
    SSID=$(ipconfig getsummary "$INTERFACE" | awk -F ' SSID : ' '/ SSID : / {print $2}')
    LABEL=${SSID:-"Wi-Fi"}
    ;;
*Ethernet* | *LAN* | *Thunderbolt* | *BASE-T*)
    LABEL="Wired"
    ;;
*)
    LABEL=${PORT:-${INTERFACE:-"Not Connected"}}
    ;;
esac

sketchybar --set "$NAME" label="$LABEL" icon="$ICON"
