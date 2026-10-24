#!/usr/bin/env bash
SSID="$1"
PASS="$2"
REMEMBER="$3"

[ -z "$SSID" ] && exit 1

if [ -n "$PASS" ] && [ "$PASS" != "null" ]; then
  if ! nmcli device wifi connect "$SSID" password "$PASS" >/dev/null 2>&1; then
    nmcli connection delete id "$SSID" >/dev/null 2>&1
    nmcli device wifi connect "$SSID" password "$PASS" >/dev/null 2>&1
  fi
else
  nmcli device wifi connect "$SSID" >/dev/null 2>&1
fi

if [ "$REMEMBER" = "false" ]; then
  nmcli connection modify id "$SSID" connection.autoconnect no >/dev/null 2>&1
fi

eww update wifi_show_list=false wifi_selected="" wifi_password="" wifi_remember=false >/dev/null 2>&1
