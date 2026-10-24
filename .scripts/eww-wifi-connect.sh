#!/usr/bin/env bash
SSID="$1"
PASS="$2"
REMEMBER="$3"

[ -z "$SSID" ] && exit 1

eww update wifi_connecting=true >/dev/null 2>&1

notify_err() {
  eww update wifi_connecting=false >/dev/null 2>&1
  notify-send -u critical -i network-wireless-offline-symbolic "Wi-Fi Error" "Unable to connect to \"$SSID\". Check your password."
}

echo "$SSID $PASS $REMEMBER" > /tmp/eww-wifi

if [ -n "$PASS" ] && [ "$PASS" != "null" ]; then
  nmcli connection delete id "$SSID" >/dev/null 2>&1
  echo "Connection Deleted $SSID" >> /tmp/eww-wifi
  if ! nmcli --wait 15 device wifi connect "$SSID" password "$PASS" >/dev/null 2>&1; then
    echo "Connection Failed $SSID" >> /tmp/eww-wifi
    notify_err
    exit 1
  fi
else
  if ! nmcli --wait 15 device wifi connect "$SSID" >/dev/null 2>&1; then
    echo "Connection Failed $SSID" >> /tmp/eww-wifi
    notify_err
    exit 1
  fi
fi

if [ "$REMEMBER" = "false" ]; then
  nmcli connection modify id "$SSID" connection.autoconnect no >/dev/null 2>&1
fi

eww update wifi_show_list=false wifi_selected="" wifi_password="" wifi_remember=false >/dev/null 2>&1
