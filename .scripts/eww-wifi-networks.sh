#!/usr/bin/env bash
nmcli -t -f SSID,SECURITY,SIGNAL,IN-USE device wifi list --rescan yes 2>/dev/null | \
awk -F: '
{
  ssid=$1; sec=$2; sig=$3; inuse=$4
  gsub(/"/, "\\\"", ssid)
  if(ssid=="") next
  if(inuse=="*") mark=1; else mark=0
  printf "%s|%s|%s|%d\n", ssid, sec, sig, mark
}' | sort -t'|' -k4 -nr -k3 -nr | \
awk -F'|' '
BEGIN{printf "["; f=0}
{
  if(f) printf ","
  printf "{\"ssid\":\"%s\",\"security\":\"%s\",\"signal\":\"%s\",\"inuse\":%s}", $1, $2, $3, ($4==1?"true":"false")
  f=1
}
END{printf "]"}'
