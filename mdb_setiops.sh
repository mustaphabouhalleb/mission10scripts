#!/usr/bin/bash
MAXIOPS=100000
DEVICE="nvme1n1"

display_usage() { 
	echo "This script must be run with super-user privileges." 
	echo -e "\nUsage: $0 IOPS \n" 
	echo "Set avaialble IOPS on a drive (cannot go above actual IOPS) "
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

if [  $1 -lt 50 ]
then
    echo "You may not turn IOPS below 50!" 
    exit 1
fi

DEVICEID=`lsblk /dev/${DEVICE} | grep ${DEVICE} | awk '{print $2}'`
echo "$DEVICEID    $1" > /sys/fs/cgroup/blkio/blkio.throttle.read_iops_device
echo "$DEVICEID    $1" > /sys/fs/cgroup/blkio/blkio.throttle.write_iops_device
echo "IOPS set to $1 for device"