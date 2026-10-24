#!/usr/bin/env bash
MAC="$1"
INFO=$(bluetoothctl info "$MAC" 2>/dev/null)
grep -q 'Paired: yes' <<< "$INFO" && PAIRED=true || PAIRED=false
grep -q 'Connected: yes' <<< "$INFO" && CONNECTED=true || CONNECTED=false

if [ "$PAIRED" = "false" ]; then
  bluetoothctl pair "$MAC" >/dev/null 2>&1
  sleep 1
  bluetoothctl trust "$MAC" >/dev/null 2>&1
  sleep 1
  bluetoothctl connect "$MAC" >/dev/null 2>&1
elif [ "$CONNECTED" = "true" ]; then
  bluetoothctl disconnect "$MAC" >/dev/null 2>&1
else
  bluetoothctl connect "$MAC" >/dev/null 2>&1
fi

eww update bt_devices="$("$HOME/.scripts/eww-bt-devices.sh")" 2>/dev/null
