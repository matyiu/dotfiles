#!/usr/bin/env bash
timeout 4 bluetoothctl scan on >/dev/null 2>&1 &
SCAN_PID=$!
sleep 3
kill $SCAN_PID >/dev/null 2>&1

DEVICES=$(bluetoothctl devices 2>/dev/null | awk '{mac=$2; $1=$2=""; sub(/^  */, ""); name=$0; gsub(/"/, "\\\"", name); print mac "|" name}')

OUT="["
FIRST=1

while IFS='|' read -r MAC NAME; do
  [ -z "$MAC" ] && continue
  INFO=$(bluetoothctl info "$MAC" 2>/dev/null)
  grep -q 'Paired: yes' <<< "$INFO" && PAIRED=true || PAIRED=false
  grep -q 'Trusted: yes' <<< "$INFO" && TRUSTED=true || TRUSTED=false
  grep -q 'Connected: yes' <<< "$INFO" && CONNECTED=true || CONNECTED=false
  grep -q 'Blocked: yes' <<< "$INFO" && BLOCKED=true || BLOCKED=false
  [ "$PAIRED" = "true" ] && [ "$CONNECTED" = "true" ] || continue
  [ $FIRST -eq 0 ] && OUT+=","
  OUT+="{\"mac\":\"$MAC\",\"name\":\"$NAME\",\"paired\":true,\"trusted\":$TRUSTED,\"connected\":true,\"blocked\":$BLOCKED}"
  FIRST=0
done <<< "$DEVICES"

while IFS='|' read -r MAC NAME; do
  [ -z "$MAC" ] && continue
  INFO=$(bluetoothctl info "$MAC" 2>/dev/null)
  grep -q 'Paired: yes' <<< "$INFO" && PAIRED=true || PAIRED=false
  grep -q 'Trusted: yes' <<< "$INFO" && TRUSTED=true || TRUSTED=false
  grep -q 'Connected: yes' <<< "$INFO" && CONNECTED=true || CONNECTED=false
  grep -q 'Blocked: yes' <<< "$INFO" && BLOCKED=true || BLOCKED=false
  [ "$PAIRED" = "true" ] && [ "$CONNECTED" = "false" ] || continue
  [ $FIRST -eq 0 ] && OUT+=","
  OUT+="{\"mac\":\"$MAC\",\"name\":\"$NAME\",\"paired\":true,\"trusted\":$TRUSTED,\"connected\":false,\"blocked\":$BLOCKED}"
  FIRST=0
done <<< "$DEVICES"

while IFS='|' read -r MAC NAME; do
  [ -z "$MAC" ] && continue
  INFO=$(bluetoothctl info "$MAC" 2>/dev/null)
  grep -q 'Paired: yes' <<< "$INFO" && PAIRED=true || PAIRED=false
  grep -q 'Trusted: yes' <<< "$INFO" && TRUSTED=true || TRUSTED=false
  grep -q 'Connected: yes' <<< "$INFO" && CONNECTED=true || CONNECTED=false
  grep -q 'Blocked: yes' <<< "$INFO" && BLOCKED=true || BLOCKED=false
  [ "$PAIRED" = "false" ] || continue
  [ $FIRST -eq 0 ] && OUT+=","
  OUT+="{\"mac\":\"$MAC\",\"name\":\"$NAME\",\"paired\":false,\"trusted\":$TRUSTED,\"connected\":false,\"blocked\":$BLOCKED}"
  FIRST=0
done <<< "$DEVICES"

OUT+="]"
echo "$OUT"
