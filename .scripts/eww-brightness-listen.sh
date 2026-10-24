#!/usr/bin/env bash

DEVICE=$(brightnessctl -l -m | head -n1 | cut -d, -f1)
PATH_DEV="/sys/class/backlight/$DEVICE"
MAX=$(cat "$PATH_DEV/max_brightness")

ACTUAL=$(cat "$PATH_DEV/actual_brightness")
echo $(( ACTUAL * 100 / MAX ))

inotifywait -m -e modify "$PATH_DEV/actual_brightness" 2>/dev/null | while read -r _; do
  ACTUAL=$(cat "$PATH_DEV/actual_brightness")
  echo $(( ACTUAL * 100 / MAX ))
done
