#!/usr/bin/env bash
CONN=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active 2>/dev/null | grep ':802-11-wireless' | head -1 | cut -d: -f1)
if [ -n "$CONN" ] && [ "$CONN" != "--" ]; then
  echo "$CONN"
else
  WIFI=$(nmcli -t -f WIFI g 2>/dev/null)
  [ "$WIFI" = "enabled" ] && echo "Connecting..." || echo "Wi-Fi"
fi
