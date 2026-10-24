#!/usr/bin/env bash
STATE="$1"
if [ "$STATE" = "true" ]; then
  eww update wifi_poll_interval=10000 2>/dev/null
else
  eww update wifi_poll_interval=999999000 2>/dev/null
fi
