#!/usr/bin/env bash
VAL="$1"
TMP="/tmp/eww-wifi-pass"
CUR="/tmp/eww-wifi-pass-cur"
echo "$VAL" > "$TMP"
sleep 0.5
if [ -f "$CUR" ]; then
  LAST=$(cat "$CUR")
  [ "$LAST" = "$VAL" ] && exit 0
fi
echo "$VAL" > "$CUR"
eww update wifi_password="$VAL" >/dev/null 2>&1
