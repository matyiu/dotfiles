#!/usr/bin/env bash

CONFIG_PATH="$HOME/.config/polybar/config"

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

while IFS='=' read -r key val; do
  key=$(echo "$key" | tr -d ' ' | tr '[:lower:]' '[:upper:]' | tr '-' '_')
  val=$(echo "$val" | tr -d ' ')
  if [ -n "$key" ] && [ -n "$val" ]; then
    export "POLYBAR_COLOR_${key}=$val"
  fi
done < <(sed -n '/^\[colors\]/,/^\[/p' "$CONFIG_PATH" | grep -E '^[^#;[]+=')

while read -r name info; do
  display="${name%:}"
  is_primary=$(echo $info | grep -o '(primary)')

  if [ "$is_primary" ]; then
    MONITOR=$display polybar primary &
  else
    MONITOR=$display polybar secondary &
  fi
done < <(polybar -m)

echo "Bars launched..."
