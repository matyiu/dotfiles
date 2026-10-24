#!/usr/bin/env bash
SSID="$1"
PASS="$2"
REMEMBER="$3"

if [ -z "$SSID" ]; then
  exit 1
fi

if [ -n "$PASS" ] && [ "$PASS" != "null" ] && [ "$PASS" != '""' ]; then
  nmcli device wifi connect "$SSID" password "$PASS" >/dev/null 2>&1
else
  nmcli device wifi connect "$SSID" >/dev/null 2>&1
fi

eww update wifi_show_list=false wifi_selected="" wifi_password="" wifi_remember=false 2>/dev/null
