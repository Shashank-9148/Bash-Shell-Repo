 Healthcheck Script

 Overview
This project contains a Bash script named `healthcheck.sh` that gathers system health information and logs it into a file called `Healthlog.txt`.



Features

The script outputs and logs the following information:

- System date and time
- System uptime
- CPU load averages
- Memory usage (using `free -m`)
- Disk usage (using `df -h`)
- Top 5 memory-consuming processes
- Status of specific services (nginx and ssh)



