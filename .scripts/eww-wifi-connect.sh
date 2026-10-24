#!/usr/bin/env bash
SSID="$1"
PASS="$2"

[ -z "$SSID" ] && exit 1
PASS_CLEAN=$(echo "$PASS" | sed "s/'//g" | sed 's/"//g')

if [ -n "$PASS_CLEAN" ] && [ "$PASS_CLEAN" != "null" ] && [ -n "$(echo -n "$PASS_CLEAN" | tr -d ' ')" ]; then
  printf "yes\n" | nmcli device wifi connect "$SSID" password "$PASS_CLEAN" 2>/dev/null
  nmcli connection up "$SSID" 2>/dev/null
else
  nmcli device wifi connect "$SSID" 2>/dev/null
  nmcli connection up "$SSID" 2>/dev/null
fi

eww update wifi_show_list=false wifi_selected="" wifi_password="" wifi_remember=false >/dev/null 2>&1
