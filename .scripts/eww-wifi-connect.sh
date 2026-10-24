#!/usr/bin/env bash
SSID="$1"
PASS="$2"
REMEMBER="$3"

[ -z "$SSID" ] && exit 1

PASS_CLEAN=$(echo "$PASS" | sed "s/'//g")

if [ -n "$PASS_CLEAN" ] && [ "$PASS_CLEAN" != "null" ] && [ "$PASS_CLEAN" != '""' ] && [ -n "$(echo $PASS_CLEAN | tr -d ' ')" ]; then
  nmcli device wifi connect "$SSID" password "$PASS_CLEAN" >/dev/null 2>&1
else
  nmcli device wifi connect "$SSID" >/dev/null 2>&1
fi

eww update wifi_show_list=false wifi_selected="" wifi_password="" wifi_remember=false >/dev/null 2>&1
