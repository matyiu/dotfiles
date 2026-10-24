#!/usr/bin/env bash
SAVED=$(nmcli -t -f NAME,TYPE connection show 2>/dev/null | grep ':802-11-wireless' | cut -d: -f1)
ACTIVE=$(nmcli -t -f ACTIVE,SSID device wifi list 2>/dev/null | grep '^yes:' | cut -d: -f2)

nmcli -t -f SSID,SECURITY,SIGNAL,IN-USE device wifi list --rescan yes 2>/dev/null | \
awk -F: -v saved="$SAVED" -v active="$ACTIVE" '
BEGIN{
  split(saved, s, "\n")
  for(i in s){ gsub(/\r/,"",s[i]); if(s[i]!="") savedmap[s[i]]=1 }
  split(active, a, "\n")
  for(i in a){ gsub(/\r/,"",a[i]); if(a[i]!="") activemap[a[i]]=1 }
}
{
  ssid=$1; sec=$2; sig=$3; inuse=$4
  gsub(/"/, "\\\"", ssid)
  if(ssid=="") next
  known = (ssid in savedmap) ? 1 : 0
  isactive = (ssid in activemap) ? 1 : 0
  if(inuse=="*") mark=1; else mark=0
  printf "%s|%s|%s|%d|%d|%d\n", ssid, sec, sig, mark, known, isactive
}' | sort -t'|' -k4 -nr -k6 -nr -k5 -nr -k3 -nr | \
awk -F'|' '
BEGIN{printf "["; f=0}
{
  if(f) printf ","
  printf "{\"ssid\":\"%s\",\"security\":\"%s\",\"signal\":\"%s\",\"inuse\":%s,\"known\":%s,\"active\":%s}", $1, $2, $3, ($4==1?"true":"false"), ($5==1?"true":"false"), ($6==1?"true":"false")
  f=1
}
END{printf "]"}'
