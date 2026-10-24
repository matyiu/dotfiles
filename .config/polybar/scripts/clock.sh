#!/usr/bin/env bash

COLOR_PRIMARY="$1"
COLOR_DISABLED="$2"

WAITING=$(dunstctl count waiting 2>/dev/null || echo 0)
DISPLAYED=$(dunstctl count displayed 2>/dev/null || echo 0)
HISTORY=$(dunstctl count history 2>/dev/null || echo 0)
TOTAL=$((DISPLAYED + HISTORY + WAITING))

if [ "$TOTAL" -gt 0 ]; then
  DOT="%{T2}%{F${COLOR_PRIMARY}}%{F-}%{T-}"
else
  DOT="%{T3}%{F${COLOR_DISABLED}}%{F-}%{T-}"
fi

date "+%H:%M  %d/%m  ${DOT}"
