#!/usr/bin/env bash

# -------------------------------------------------------------
# SYSTEM LOAD
# -------------------------------------------------------------
RAM_USAGE=$(free | awk '/Mem:/ {printf("%d", $3/$2 * 100)}')
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%d", 100 - $1)}')

C_CRITICAL="#E47878"
C_HIGH="#E59765"
C_MEDIUM="#E5C765"
C_LOW="#0DB9A2"
C_IDLE="#5DA5DE"

ICON_CRITICAL="󰪥"
ICON_HIGH="󰪤"
ICON_MEDIUM="󰪢"
ICON_LOW="󰪠"
ICON_IDLE="󰪞"

[ "$RAM_USAGE" -gt "$CPU_USAGE" ] && MAX_LOAD=$RAM_USAGE || MAX_LOAD=$CPU_USAGE

if [ "$RAM_USAGE" -gt 80 ]; then
  LOAD_COLOR="$C_CRITICAL"
  LOAD_GLYPH="$ICON_CRITICAL"
elif [ "$CPU_USAGE" -gt 70 ]; then
  LOAD_COLOR="$C_HIGH"
  LOAD_GLYPH="$ICON_HIGH"
elif [ "$MAX_LOAD" -ge 50 ]; then
  LOAD_COLOR="$C_MEDIUM"
  LOAD_GLYPH="$ICON_MEDIUM"
elif [ "$MAX_LOAD" -ge 15 ]; then
  LOAD_COLOR="$C_LOW"
  LOAD_GLYPH="$ICON_LOW"
else
  LOAD_COLOR="$C_IDLE"
  LOAD_GLYPH="$ICON_IDLE"
fi

LOAD_ICON="%{F${LOAD_COLOR}}${LOAD_GLYPH}%{F-}"

# -------------------------------------------------------------
# NETWORK
# -------------------------------------------------------------
ICON_NET_DISCONNECTED="󰤮"
ICON_NET_ETHERNET="󰈀"
ICON_NET_WIFI_FULL="󰤨"
ICON_NET_WIFI_HIGH="󰤥"
ICON_NET_WIFI_MID="󰤢"
ICON_NET_WIFI_LOW="󰤟"

COLOR_WHITE="#FFFFFF"
COLOR_MUTED="#707880"

WLAN_IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^wl' | head -n 1)
ETH_IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^(en|eth)' | head -n 1)

NET_ICON="%{T5}%{F${COLOR_MUTED}}${ICON_NET_DISCONNECTED}%{F-}%{T-}"

if [ -n "$ETH_IFACE" ] && [ "$(cat /sys/class/net/"$ETH_IFACE"/operstate 2>/dev/null)" = "up" ]; then
  NET_ICON="%{T5}%{F${COLOR_WHITE}}${ICON_NET_ETHERNET}%{F-}%{T-}"
elif [ -n "$WLAN_IFACE" ] && [ "$(cat /sys/class/net/"$WLAN_IFACE"/operstate 2>/dev/null)" = "up" ]; then
  SIGNAL=$(awk 'NR==3 {gsub(/\./, "", $3); print int($3)}' /proc/net/wireless 2>/dev/null)
  if [ -z "$SIGNAL" ] || [ "$SIGNAL" -ge 70 ]; then
    NET_ICON="%{T5}%{F${COLOR_WHITE}}${ICON_NET_WIFI_FULL}%{F-}%{T-}"
  elif [ "$SIGNAL" -ge 50 ]; then
    NET_ICON="%{T5}%{F${COLOR_WHITE}}${ICON_NET_WIFI_HIGH}%{F-}%{T-}"
  elif [ "$SIGNAL" -ge 30 ]; then
    NET_ICON="%{T5}%{F${COLOR_WHITE}}${ICON_NET_WIFI_MID}%{F-}%{T-}"
  else
    NET_ICON="%{T5}%{F${COLOR_WHITE}}${ICON_NET_WIFI_LOW}%{F-}%{T-}"
  fi
fi

# -------------------------------------------------------------
# BRIGHTNESS
# -------------------------------------------------------------
ICON_BRI_100="󰛨"
ICON_BRI_80="󰛩"
ICON_BRI_60="󱩎"
ICON_BRI_40="󱩏"
ICON_BRI_20="󱩐"
ICON_BRI_0="󰛪"

COLOR_WHITE="#FFFFFF"

if command -v brightnessctl >/dev/null 2>&1; then
  B_PERC=$(brightnessctl -m 2>/dev/null | awk -F, '{print sub(/%/, "", $4) ? $4 : 0}')
else
  BACKLIGHT_DIR=$(ls -d /sys/class/backlight/* 2>/dev/null | head -n 1)
  if [ -n "$BACKLIGHT_DIR" ]; then
    CUR=$(cat "$BACKLIGHT_DIR/brightness" 2>/dev/null || echo 0)
    MAX=$(cat "$BACKLIGHT_DIR/max_brightness" 2>/dev/null || echo 1)
    B_PERC=$(( CUR * 100 / MAX ))
  else
    B_PERC=100
  fi
fi

if [ "$B_PERC" -ge 85 ]; then
  BRI_GLYPH="$ICON_BRI_100"
elif [ "$B_PERC" -ge 65 ]; then
  BRI_GLYPH="$ICON_BRI_80"
elif [ "$B_PERC" -ge 45 ]; then
  BRI_GLYPH="$ICON_BRI_60"
elif [ "$B_PERC" -ge 25 ]; then
  BRI_GLYPH="$ICON_BRI_40"
elif [ "$B_PERC" -ge 10 ]; then
  BRI_GLYPH="$ICON_BRI_20"
else
  BRI_GLYPH="$ICON_BRI_0"
fi

BRIGHT_ICON="%{T5}%{F${COLOR_WHITE}}${BRI_GLYPH}%{F-}%{T-}"

# -------------------------------------------------------------
# VOLUME
# -------------------------------------------------------------
ICON_VOL_MUTE="󰝟"
ICON_VOL_HIGH="󰕾"
ICON_VOL_MED="󰖀"
ICON_VOL_LOW="󰕿"

COLOR_WHITE="#FFFFFF"
COLOR_MUTED="#707880"

WP_STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)

if [ -z "$WP_STATUS" ]; then
  VOL_MUTED="false"
  VOL_LEVEL=0
else
  [[ "$WP_STATUS" =~ \[MUTED\] ]] && VOL_MUTED="true" || VOL_MUTED="false"
  VOL_FLOAT=$(echo "$WP_STATUS" | awk '{print $2}')
  VOL_LEVEL=$(awk -v v="$VOL_FLOAT" 'BEGIN {printf("%d", v * 100)}')
fi

if [ "$VOL_MUTED" = "true" ] || [ "$VOL_MUTED" = "1" ]; then
  VOL_ICON="%{T5}%{F${COLOR_MUTED}}${ICON_VOL_MUTE}%{F-}%{T-}"
elif [ "$VOL_LEVEL" -ge 60 ]; then
  VOL_ICON="%{T5}%{F${COLOR_WHITE}}${ICON_VOL_HIGH}%{F-}%{T-}"
elif [ "$VOL_LEVEL" -ge 20 ]; then
  VOL_ICON="%{T5}%{F${COLOR_WHITE}}${ICON_VOL_MED}%{F-}%{T-}"
else
  VOL_ICON="%{T5}%{F${COLOR_WHITE}}${ICON_VOL_LOW}%{F-}%{T-}"
fi

# -------------------------------------------------------------
# BATTERY
# -------------------------------------------------------------
BAT_DIR=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
BAT_ICON=""
BAT_PERC=""

if [ -n "$BAT_DIR" ]; then
  BAT_PERC="$(cat "$BAT_DIR/capacity" 2>/dev/null)%"
  STATUS=$(cat "$BAT_DIR/status" 2>/dev/null)
  CAP=$(cat "$BAT_DIR/capacity" 2>/dev/null)

  if [ "$STATUS" = "Charging" ]; then
    BAT_ICON="󰂄"
  elif [ "$CAP" -ge 80 ]; then
    BAT_ICON=""
  elif [ "$CAP" -ge 60 ]; then
    BAT_ICON=""
  elif [ "$CAP" -ge 40 ]; then
    BAT_ICON=""
  elif [ "$CAP" -ge 15 ]; then
    BAT_ICON=""
  else
    BAT_ICON="%{F#E47878}%{F-}"
  fi
fi

echo "${LOAD_ICON}  ${NET_ICON}  ${BRIGHT_ICON}  ${VOL_ICON}  ${BAT_ICON} ${BAT_PERC}"
