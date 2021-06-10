#!/usr/bin/bash
MAXCPU=32

display_usage() { 
	echo "This script must be run with super-user privileges." 
	echo -e "\nUsage: $0 [MB] \n" 
	echo "Limit number of runnign CPU cores "
	} 

if [  $# -lt 1 ] 
then 
    display_usage
    exit 1
fi 

if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
        echo "Here"
	display_usage
	exit 0
fi 

# display usage if the script is not run as root user 
if [[ "$EUID" -ne 0 ]]; then 
	echo "This script must be run as root!" 
	exit 1
fi 

if [  $1 -lt 1 ]
then
    echo "You may not turn off ALL the CPUs!" 
    exit 1
fi


for c in `seq 1 $1`
do
	if [ -f /sys/devices/system/cpu/cpu${c}/online ];then
		echo 1 > /sys/devices/system/cpu/cpu$c/online 2>/dev/null
	fi
done

for c in `seq $1 $MAXCPU`
do
	if [ -f /sys/devices/system/cpu/cpu${c}/online ];then
	   echo 0 > /sys/devices/system/cpu/cpu$c/online 2>/dev/null
    fi
done

lscpu | grep list
