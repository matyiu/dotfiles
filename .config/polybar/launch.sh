#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

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
