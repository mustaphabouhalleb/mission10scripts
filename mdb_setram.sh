#!/usr/bin/bash
MAXRAM=16384

display_usage() { 
	echo "This script must be run with super-user privileges." 
	echo -e "\nUsage: $0 [MB] \n" 
	echo "Limit RAM to a  given number of MB - will reboot the server"
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

if [  $1 -lt 512 ]
then
    echo "You may not set it lower than 512MB!" 
    exit 1
fi

if [  $1 -gt $MAXRAM ]
then
    echo "You may not set it higher than ${MAXRAM}MB!" 
    exit 1
fi

echo "Setting RAM to $1 Megabytes and rebooting"
cat << ENDGRUB | sudo tee /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 nvme_core.io_timeout=4294967295 mem=${1}M"
GRUB_TIMEOUT=0
ENDGRUB

sudo grub2-mkconfig -o /boot/grub2/grub.cfg && sudo reboot
