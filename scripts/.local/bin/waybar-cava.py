#!/usr/bin/env python3
import sys
import subprocess

bars = { '0': ' ', '1': '▂', '2': '▃', '3': '▄', '4': '▅', '5': '▆', '6': '▇', '7': '█' }

p = subprocess.Popen(["cava", "-p", "/home/prof3ssor/.config/cava/config_waybar"], stdout=subprocess.PIPE, text=True)

try:
    for line in iter(p.stdout.readline, ''):
        nums = line.strip().split(';')[:-1]
        out = "".join([bars.get(n, ' ') for n in nums])
        print(f'{{"text": "{out}"}}', flush=True)
except Exception:
    pass
