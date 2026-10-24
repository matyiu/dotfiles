#!/usr/bin/env bash
SSID="$1"
PASS="$2"

[ -z "$SSID" ] && exit 1
PASS_CLEAN=$(printf "%s" "$PASS" | sed "s/'//g" | sed 's/"//g')

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

if [ -n "$PASS_CLEAN" ] && [ "$PASS_CLEAN" != "null" ] && [ ${#PASS_CLEAN} -gt 0 ]; then
  nmcli --ask device wifi connect "$SSID" password "$PASS_CLEAN" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    nmcli connection delete "$SSID" 2>/dev/null
    nmcli device wifi connect "$SSID" password "$PASS_CLEAN" >/dev/null 2>&1
  fi
else
  nmcli device wifi connect "$SSID" >/dev/null 2>&1
fi

eww update wifi_show_list=false wifi_selected="" wifi_password="" wifi_remember=false >/dev/null 2>&1
