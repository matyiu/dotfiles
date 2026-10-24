#!/usr/bin/env bash
VAL="${1%.*}"

[ -z "$VAL" ] && exit 0

LOCK="/tmp/eww-brightness.lock"

exec 200>"$LOCK"
flock -n 200 || exit 0

brightnessctl set "${VAL}%" -q >/dev/null 2>&1
eww update current_brightness="$VAL" >/dev/null 2>&1

flock -u 200
