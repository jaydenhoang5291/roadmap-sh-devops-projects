# Server Performance Stats

This project contains a Bash script named `server-stats.sh` that displays basic performance information for a Linux server.

Project URL: https://roadmap.sh/projects/server-stats

## Requirements

The script shows:

- CPU usage
- Memory usage
- Disk usage
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

## File

```bash
server-stats.sh
```

## How to Run

Give the script execute permission:

```bash
chmod +x server-stats.sh
```

Run the script:

```bash
./server-stats.sh
```

## What the Script Uses

The script uses common Linux commands:

- `top` to show CPU and system activity
- `free -h` to show memory usage
- `df -h` to show disk usage
- `ps` to list processes
- `head` to limit the process list to the top 5 results

## Output Sections

### CPU Usage

Shows current CPU and system activity using:

```bash
top
```

Note: `top` runs continuously. Press `q` to quit and continue using the terminal.

### Memory Usage

Shows total, used, and free memory:

```bash
free -h
```

### Disk Usage

Shows disk space usage in a human-readable format:

```bash
df -h
```

### Top 5 Processes by CPU Usage

Shows the 5 processes using the most CPU:

```bash
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
```

### Top 5 Processes by Memory Usage

Shows the 5 processes using the most memory:

```bash
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
```

## Notes

This script is intended for learning basic Linux server monitoring. It can be improved by making the CPU section non-interactive with `top -bn1`, or by adding extra stats such as OS version, uptime, load average, and logged-in users.
