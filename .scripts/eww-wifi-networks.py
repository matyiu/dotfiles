#!/usr/bin/env python3
import subprocess
import json

def get_output(cmd):
    try:
        res = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return res.stdout.strip().splitlines()
    except subprocess.SubprocessError:
        return []

saved_lines = get_output(["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show"])
saved_ssids = {
    line.split(":")[0] for line in saved_lines if line.endswith(":802-11-wireless")
}

wifi_lines = get_output([
    "nmcli", "-t", "-f", "SSID,SECURITY,SIGNAL,IN-USE", "device", "wifi", "list", "--rescan", "no"
])

networks = {}
for line in wifi_lines:
    parts = line.split(":")
    if len(parts) < 4:
        continue
    
    ssid = parts[0].strip()
    if not ssid:
        continue

    sec = parts[1] if parts[1] and parts[1] != "--" else "--"
    try:
        sig = int(parts[2])
    except ValueError:
        sig = 0
    inuse = parts[3] == "*"

    if ssid not in networks or inuse or (sig > networks[ssid]["signal"] and not networks[ssid]["inuse"]):
        networks[ssid] = {
            "ssid": ssid,
            "security": sec,
            "signal": sig,
            "inuse": inuse,
            "saved": ssid in saved_ssids
        }

sorted_list = sorted(
    networks.values(),
    key=lambda x: (x["inuse"], x["saved"], x["signal"]),
    reverse=True
)

print(json.dumps(sorted_list))
