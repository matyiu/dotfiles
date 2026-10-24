#!/usr/bin/env bash
SSID="$1"
[ -z "$SSID" ] && exit 1
nmcli connection delete id "$SSID" >/dev/null 2>&1
eww update wifi_show_list=false wifi_selected="" wifi_password="" wifi_remember=false >/dev/null 2>&1
