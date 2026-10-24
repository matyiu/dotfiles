#!/usr/bin/env python3
import json, time, os, subprocess, glob

cpu_temp = "N/A"
for t_path in glob.glob("/sys/class/thermal/thermal_zone*/temp") + glob.glob("/sys/class/hwmon/hwmon*/temp1_input"):
    try:
        with open(t_path, "r") as f:
            t = int(f.read().strip())
            if 10000 < t < 115000:
                cpu_temp = f"{round(t / 1000)}°C"
                break
    except Exception:
        continue

try:
    with open("/proc/loadavg", "r") as f:
        lavg = f.read().split()[:3]
        load_avg = f"{lavg[0]} {lavg[1]} {lavg[2]}"
except Exception:
    load_avg = "- - -"

def get_cpu_lines():
    with open("/proc/stat", "r") as f:
        return [l.strip().split() for l in f if l.startswith("cpu")]

lines1 = get_cpu_lines()
time.sleep(0.08)
lines2 = get_cpu_lines()

cores_list = []
total_cpu_perc = 0

for c1, c2 in zip(lines1, lines2):
    f1 = [float(x) for x in c1[1:]]
    f2 = [float(x) for x in c2[1:]]
    d_tot = sum(f2) - sum(f1)
    d_idle = (f2[3] + f2[4]) - (f1[3] + f1[4])
    perc = int(((d_tot - d_idle) / d_tot) * 100) if d_tot else 0
    if c1[0] == "cpu":
        total_cpu_perc = perc
    else:
        cid = c1[0].replace("cpu", "")
        cores_list.append({"id": cid, "perc": perc})

mhz_list = []
cpu_model = "x86_64 CPU"
try:
    with open("/proc/cpuinfo", "r") as f:
        for line in f:
            if "model name" in line and cpu_model == "x86_64 CPU":
                cpu_model = line.split(":")[1].strip().split("@")[0].strip()
            if "cpu MHz" in line:
                mhz_list.append(float(line.split(":")[1].strip()))
    avg_mhz = sum(mhz_list) / len(mhz_list) if mhz_list else 0
    cpu_ghz = f"{round(avg_mhz / 1000, 2):.2f} GHz"
except Exception:
    cpu_ghz = "0.00 GHz"

mem = {}
try:
    with open("/proc/meminfo", "r") as f:
        for line in f:
            p = line.split(":")
            if len(p) == 2:
                mem[p[0].strip()] = int(p[1].strip().split()[0])
    
    total_mb = mem.get("MemTotal", 1) // 1024
    avail_mb = mem.get("MemAvailable", 0) // 1024
    used_mb = total_mb - avail_mb
    ram_perc = int((used_mb / total_mb) * 100) if total_mb else 0
    
    buffers_mb = mem.get("Buffers", 0) // 1024
    cached_mb = mem.get("Cached", 0) // 1024
    dirty_mb = mem.get("Dirty", 0) // 1024

    s_total_mb = mem.get("SwapTotal", 0) // 1024
    s_free_mb = mem.get("SwapFree", 0) // 1024
    s_used_mb = s_total_mb - s_free_mb
    swap_perc = int((s_used_mb / s_total_mb) * 100) if s_total_mb else 0

    ram_used_gb = f"{used_mb / 1024:.2f} GB"
    ram_total_gb = f"{total_mb / 1024:.2f} GB"
    ram_avail_gb = f"{avail_mb / 1024:.2f} GB"
    ram_cache_gb = f"{(buffers_mb + cached_mb) / 1024:.2f} GB"
    swap_used_gb = f"{s_used_mb / 1024:.2f} GB"
    swap_total_gb = f"{s_total_mb / 1024:.2f} GB"
except Exception:
    ram_perc, swap_perc = 0, 0
    ram_used_gb, ram_total_gb, ram_avail_gb, ram_cache_gb = "0 GB", "0 GB", "0 GB", "0 GB"
    swap_used_gb, swap_total_gb = "0 GB", "0 GB"

# --- 3. DUAL GPU (iGPU + dGPU) ---
gpu0 = {"name": "iGPU (Intel/AMD)", "perc": 0, "mem": "Memoria compartida", "temp": "N/A"}
gpu1 = {"name": "dGPU (NVIDIA)", "perc": 0, "mem": "0 / 0 MB", "temp": "N/A"}

# 3.1 Detección NVIDIA (dGPU primaria habitual)
try:
    smi = subprocess.check_output(
        ["nvidia-smi", "--query-gpu=name,utilization.gpu,memory.used,memory.total,temperature.gpu", "--format=csv,noheader,nounits"],
        text=True, stderr=subprocess.DEVNULL
    ).strip().split("\n")
    if smi and smi[0]:
        parts = [p.strip() for p in smi[0].split(",")]
        gpu1["name"] = parts[0][:20]
        gpu1["perc"] = int(parts[1])
        gpu1["mem"] = f"{parts[2]} / {parts[3]} MB"
        gpu1["temp"] = f"{parts[4]}°C"
except Exception:
    pass

# 3.2 Detección DRM / sysfs (iGPU o AMD)
drm_cards = sorted(glob.glob("/sys/class/drm/card[0-9]/device"))
for card in drm_cards:
    busy_path = os.path.join(card, "gpu_busy_percent")
    if os.path.exists(busy_path):
        try:
            with open(busy_path, "r") as f:
                gpu0["perc"] = int(f.read().strip())
        except Exception:
            pass

    for hwmon in glob.glob(os.path.join(card, "hwmon/hwmon*/temp1_input")):
        try:
            with open(hwmon, "r") as f:
                t = int(f.read().strip())
                gpu0["temp"] = f"{round(t / 1000)}°C"
                break
        except Exception:
            pass

# --- 4. RED & INTERFACES DETALLADAS ---
default_iface = "red"
local_ip = "127.0.0.1"
try:
    r_route = subprocess.check_output(["ip", "route", "get", "1.1.1.1"], text=True, stderr=subprocess.DEVNULL)
    parts = r_route.split()
    if "dev" in parts:
        default_iface = parts[parts.index("dev") + 1]
    if "src" in parts:
        local_ip = parts[parts.index("src") + 1]
except Exception:
    pass

def read_iface_counters():
    rx, tx = 0, 0
    with open("/proc/net/dev", "r") as f:
        for line in f:
            if ":" in line and not line.strip().startswith("lo"):
                p = line.split(":")
                dev_name = p[0].strip()
                vals = p[1].split()
                if default_iface in dev_name or rx == 0:
                    rx = int(vals[0])
                    tx = int(vals[8])
    return rx, tx

rx_1, tx_1 = read_iface_counters()
time.sleep(0.04)
rx_2, tx_2 = read_iface_counters()
rx_kbs = int((rx_2 - rx_1) / 1024 / 0.04)
tx_kbs = int((tx_2 - tx_1) / 1024 / 0.04)

print(json.dumps({
    "cpu": {
        "model": cpu_model,
        "perc": total_cpu_perc,
        "ghz": cpu_ghz,
        "cores_count": len(cores_list),
        "cores": cores_list,
        "temp": cpu_temp,
        "load": load_avg
    },
    "ram": {
        "perc": ram_perc,
        "used": ram_used_gb,
        "total": ram_total_gb,
        "avail": ram_avail_gb,
        "cache": ram_cache_gb,
        "swap_perc": swap_perc,
        "swap_used": swap_used_gb,
        "swap_total": swap_total_gb
    },
    "gpu0": gpu0,
    "gpu1": gpu1,
    "net": {
        "iface": default_iface,
        "ip": local_ip,
        "rx_kbs": f"{rx_kbs} KB/s",
        "tx_kbs": f"{tx_kbs} KB/s",
        "rx_perc": min(100, int(rx_kbs / 50)),
        "tx_perc": min(100, int(tx_kbs / 50))
    }
}))
