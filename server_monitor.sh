#!/bin/bash
# اسکریپت مانیتورینگ منابع سرور (CPU, RAM, Disk, Network)
# مناسب اجرا دستی یا اتوماتیک (مثلا هر دقیقه با کرون)

while true; do
    clear
    echo "========= مانیتورینگ منابع سرور ========="
    echo "زمان: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "------ مصرف CPU ------"
    top -b -n 1 | grep "Cpu(s)" | awk '{print $2 + $4}' | xargs printf "CPU Usage: %.2f%%\n"
    echo "------ مصرف RAM ------"
    free -h | awk '/Mem:/ {print "RAM Used: "$3 " / " $2}'
    echo "------ مصرف دیسک ------"
    df -h / | awk 'NR==2 {print "Disk Used: "$3 " / " $2}'
    echo "------ مصرف شبکه ------"
    ifstat 1 1 | awk 'NR==3 {print "Network IN: "$1" KB/s | OUT: "$2" KB/s"}'
    echo "------ ۵ سرویس پرمصرف ------"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
    sleep 5
done
