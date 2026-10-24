#!/usr/bin/env bash
if systemctl is-active --quiet AmneziaVPN.service 2>/dev/null; then
  systemctl stop AmneziaVPN.service 2>/dev/null
  if [ $? -ne 0 ]; then
    pkexec systemctl stop AmneziaVPN.service >/dev/null 2>&1
  fi
else
  systemctl start AmneziaVPN.service 2>/dev/null
  if [ $? -ne 0 ]; then
    pkexec systemctl start AmneziaVPN.service >/dev/null 2>&1
  fi
  sleep 1
  pgrep -f 'AmneziaVPN/client|/opt/AmneziaVPN/client' >/dev/null || {
    "$HOME/Apps/AmneziaVPN"* 2>/dev/null || /usr/bin/AmneziaVPN 2>/dev/null || AmneziaVPN 2>/dev/null &
  }
fi
