#!/usr/bin/env bash
if systemctl is-active --quiet AmneziaVPN.service 2>/dev/null || pgrep -f AmneziaVPN >/dev/null; then
  systemctl stop AmneziaVPN.service 2>/dev/null
  if [ $? -ne 0 ]; then
    pkexec systemctl stop AmneziaVPN.service >/dev/null 2>&1
  fi
  if [ $? -ne 0 ]; then
    pkexec sh -c "pkill -TERM -f AmneziaVPN-service 2>/dev/null; pkill -TERM -f /opt/AmneziaVPN 2>/dev/null; pkill -TERM -f AmneziaVPN 2>/dev/null; sleep 2; pkill -KILL -f AmneziaVPN 2>/dev/null" >/dev/null 2>&1
  fi
else
  "$HOME/Apps/AmneziaVPN"* 2>/dev/null || /usr/bin/AmneziaVPN 2>/dev/null || AmneziaVPN 2>/dev/null &
fi
