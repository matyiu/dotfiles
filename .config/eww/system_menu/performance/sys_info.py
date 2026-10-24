#!/usr/bin/env python3
import json, time, os, subprocess, glob

mem = {}
try:
    with open("/proc/meminfo", "r") as f:
        for line in f:
            p = line.split(":")
            if len(p) == 2:
                mem[p[0].strip()] = int(p[1].strip().split()[0])
    total_gb = mem.get("MemTotal", 1) / 1024 / 1024
    avail_gb = mem.get("MemAvailable", 0) / 1024 / 1024
    used_gb = total_gb - avail_gb
    ram_perc = int((used_gb / total_gb) * 100) if total_gb else 0

    s_total_gb = mem.get("SwapTotal", 0) / 1024 / 1024
    s_free_gb = mem.get("SwapFree", 0) / 1024 / 1024
    s_used_gb = s_total_gb - s_free_gb
    swap_perc = int((s_used_gb / s_total_gb) * 100) if s_total_gb else 0
except Exception:
    total_gb, avail_gb, used_gb, ram_perc, s_total_gb, s_used_gb, swap_perc = 1.0, 0.0, 0.0, 0, 0.0, 0.0, 0

def get_cpu_lines():
    with open("/proc/stat", "r") as f:
        return [l.strip().split() for l in f if l.startswith("cpu")]

lines1 = get_cpu_lines()
time.sleep(0.08)
lines2 = get_cpu_lines()

cores_data = {}
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
        cores_data[f"c{cid}"] = perc

for i in range(8):
    if f"c{i}" not in cores_data:
        cores_data[f"c{i}"] = 0

mhz = 0
try:
    with open("/proc/cpuinfo", "r") as f:
        for line in f:
            if "cpu MHz" in line:
                mhz = float(line.split(":")[1].strip())
                break
except Exception:
    pass

gpu0_perc = 0
gpu0_mem = "0 / 0 MB"
gpu0_name = "iGPU"

gpu1_perc = 0
gpu1_mem = "0 / 0 MB"
gpu1_name = "dGPU"

try:
    smi = subprocess.check_output(
        ["nvidia-smi", "--query-gpu=utilization.gpu,memory.used,memory.total,name", "--format=csv,noheader,nounits"],
        text=True, stderr=subprocess.DEVNULL
    ).strip().split("\n")
    if len(smi) >= 1 and smi[0]:
        parts = [p.strip() for p in smi[0].split(",")]
        gpu1_perc = int(parts[0])
        gpu1_mem = f"{parts[1]} / {parts[2]} MB"
        gpu1_name = parts[3][:14]
except Exception:
    pass

drm_busy = sorted(glob.glob("/sys/class/drm/card*/device/gpu_busy_percent"))
if drm_busy:
    try:
        with open(drm_busy[0], "r") as f:
            gpu0_perc = int(f.read().strip())
            gpu0_name = "Intel/AMD iGPU"
    except Exception:
        pass
    if len(drm_busy) > 1 and gpu1_perc == 0:
        try:
            with open(drm_busy[1], "r") as f:
                gpu1_perc = int(f.read().strip())
                gpu1_name = "Secondary GPU"
        except Exception:
            pass

def get_net_bytes():
    rx, tx = 0, 0
    with open("/proc/net/dev", "r") as f:
        for line in f:
            if ":" in line and not line.strip().startswith("lo"):
                parts = line.split(":")[1].split()
                rx += int(parts[0])
                tx += int(parts[8])
    return rx, tx

rx1, tx1 = get_net_bytes()
time.sleep(0.04)
rx2, tx2 = get_net_bytes()
rx_kbs = int((rx2 - rx1) / 1024 / 0.04)
tx_kbs = int((tx2 - tx1) / 1024 / 0.04)

rx_plot = min(100, int(rx_kbs / 50))
tx_plot = min(100, int(tx_kbs / 50))

top = []
try:
    out = subprocess.check_output(["ps", "-eo", "comm,%cpu,%mem", "--sort=-%cpu", "--no-headers"], text=True)
    for line in out.strip().split("\n")[:8]:
        parts = line.split()
        if len(parts) >= 3:
            top.append({"name": parts[0][:15], "cpu": f"{parts[-2]}%", "mem": f"{parts[-1]}%"})
except Exception:
    pass

print(json.dumps({
    "cpu_perc": total_cpu_perc,
    "cpu_ghz": f"{round(mhz / 1000, 2):.2f} GHz",
    "cpu_cores": f"{len([k for k in cores_data if cores_data[k] > 0 or True])} núcleos",
    "cores": cores_data,
    "ram_perc": ram_perc,
    "ram_used": f"{used_gb:.1f} GB",
    "ram_avail": f"{avail_gb:.1f} GB",
    "ram_total": f"{total_gb:.1f} GB",
    "swap_perc": swap_perc,
    "swap_used": f"{s_used_gb:.1f} GB",
    "swap_total": f"{s_total_gb:.1f} GB",
    "gpu0_perc": gpu0_perc,
    "gpu0_mem": gpu0_mem,
    "gpu0_name": gpu0_name,
    "gpu1_perc": gpu1_perc,
    "gpu1_mem": gpu1_mem,
    "gpu1_name": gpu1_name,
    "net_rx": f"{rx_kbs} K/s",
    "net_tx": f"{tx_kbs} K/s",
    "net_rx_val": rx_plot,
    "net_tx_val": tx_plot,
    "top": top
}))
