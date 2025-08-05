#!/bin/bash

# File:Healthcheck.sh

#create timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
log_file="Healthlog.txt"

echo "-------------------------------------------------------------">> $log_file
echo "Health Check -$timestamp" >> $log_file
echo "-------------------------------------------------------------">> $log_file

#System date and time
echo " Date & Time : $timestamp" >> $log_file

#System uptime
echo " Uptime: $(uptime -p)" >> $log_file

#Cpu load
echo "CPU Load: $(uptime | awk -F'load average:' '{print $2 }')" >> $log_file

#Memory usage
echo "Memory usage:" >>$log_file
free -m >> $log_file

#Disk usage
echo " Disk usage:" >>$log_file
df -h >> $log_file

#Top 5 memory consuming processes
echo "Top 5 Memory Consuming Processes:">> $log_file
ps aux --sort=-%mem | head -n 6 >> $log_file

#check if services are running
if [ "$#" -eq 0 ]; then
    echo "No services were specified to check." >> $LOGFILE
else
    echo "Service Status:" >> $LOGFILE
    for SERVICE in "$@"; do
        STATUS=$(systemctl is-active $SERVICE 2>/dev/null)
        if [ "$STATUS" == "active" ]; then
            echo "$SERVICE: running" >> $LOGFILE
        elif [ "$STATUS" == "inactive" ]; then
            echo "$SERVICE: not running" >> $LOGFILE
        elif [ "$STATUS" == "unknown" ]; then
            echo "$SERVICE: unknown service" >> $LOGFILE
        else
            echo "$SERVICE: $STATUS" >> $LOGFILE
        fi
    done
fi

echo "" >> "$log_file"



