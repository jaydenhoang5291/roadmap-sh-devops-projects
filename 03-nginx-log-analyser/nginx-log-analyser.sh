#!/bin/bash

LOG_FILE="access.log"

echo "Top 5 IP addresses:"
awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -5

echo ""
echo "Top 5 requested paths:"
awk -F'"' '{print $2}' $LOG_FILE | awk '{print $2}' | sort | uniq -c | sort -nr | head -5

echo ""
echo "Top 5 status codes:"
awk -F'"' '{print $3}' $LOG_FILE | awk '{print $1}' | sort | uniq -c | sort -nr | head -5

echo ""
echo "Top 5 user agents:"
awk -F'"' '{print $6}' $LOG_FILE | sort | uniq -c | sort -nr | head -5