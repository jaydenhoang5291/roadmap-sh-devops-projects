#!/bin/bash

echo "======== Server Performance Stats ========"

# CPU Usage
echo "==== CPU Usage ===="
top

echo

# Memory Usage
echo "==== Memory Usage ====="
free -h

echo

# Disk Usage
echo "==== Disk Usage ===="
df -h

echo

# Top 5 Processes by CPU Usage
echo "==== Top 5 Processes by CPU Usage ===="
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

echo

# Top 5 Processes by Memory Usage
echo "==== Top 5 Processes by Memory Usage ===="
ps -eo pid,comm,%mem --sort=-%mem | head -n 6