#!/usr/bin/env bash

if [ -n "$1" ]; then
  DAY="$1"
  MONTH="$2"
  YEAR="$3"

  CORRECT_MONTH=$((MONTH + 1))
  FORMATTED_DATE=$(printf "%04d-%02d-%02d" "$YEAR" "$CORRECT_MONTH" "$DAY")

  RAW=$(omacal events list --from "$FORMATTED_DATE" --to "$FORMATTED_DATE" --json 2>/dev/null)
else
  RAW=$(omacal agenda --days 1 --json 2>/dev/null)
fi

PARSED=$(echo "$RAW" | jq -c '{
  all_day: [.data[]? | select(.allDay == true) | {
    title: .title,
    location: (.location // "")
  }] // [],
  timed: [.data[]? | select(.allDay != true) | {
    time: (.start[11:16] + " — " + .end[11:16]),
    title: .title,
    location: (.location // "")
  }] // []
}' 2>/dev/null)

if [ -z "$PARSED" ] || [ "$PARSED" = "null" ]; then
  PARSED='{"all_day":[],"timed":[]}'
fi

if [ -n "$1" ]; then
  eww update omacal_agenda="$PARSED"
else
  echo "$PARSED"
fi
