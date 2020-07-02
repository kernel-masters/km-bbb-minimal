#!/bin/sh 



# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
NC='\033[0m'              # No Color
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

BRedU='\033[4;31m'         # Red

KERNEL_UTS="4.19.94-Kernel-Masters"
#echo "Busy Box defconfig"


echo "${Green}-----------------------------"
echo -n ${Red}"Check No. of CPUS:${NC}"
export cpus=`cat /proc/cpuinfo | grep processor | wc -l`
echo $cpus
echo "${Green}-----------------------------${NC}"
echo "";echo ""

echo "${Green}-----------------------------"
echo "${Red}Check busybox-1.31.1 folder:"
echo "${Green}-----------------------------${NC}"
if [ -d busybox-1.31.1 ] ; then
        echo "${Red} busybox folder is found"
else
	echo "extract busybox..."
	tar -xvf busybox-1.31.1.tar.bz2
fi

cd busybox-1.31.1

echo "${Green}-----------------------------"
echo "${Red}Check .config file:"
echo "${Green}-----------------------------${NC}"
if [ -f .config ] ; then
        echo "${Red}~/.config file found.[BusyBox Configuration has DONE]"
        echo "If you want to configure the kernel again type \"yes\" otherwise \"no\" to skip kernel configuration${NC}"
        read  temp
        if [ $temp = "yes" ];then
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
        fi
else
        echo "${Green}~/.config file not found [BusyBox Configuration has not done]."
        echo "Please configure the busybox for further steps.${NC}"
        x=5
        while [ "$x" -ne 0 ]; do
                echo -n "$x "
                x=$(($x-1))
                sleep 1
        done
        echo "${Purple}cp ../busybox_bbb.confg .config${NC}"
	cp ../busybox_bbb.confg .config
        echo "${Green}BusyBox Configuration has done successfully"
fi

        echo "make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j${cpus}"
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j${cpus}
cd ..
