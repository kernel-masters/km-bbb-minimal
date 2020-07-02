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

export KM_BBB_KERNEL=/home/$USER/KM_GITHUB/beagleboneblack-kernel

KERNEL_UTS=$(cat "${KM_BBB_KERNEL}/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )

#echo "Busy Box defconfig"

echo "${Green}-----------------------------"
echo -n ${Red}"Check No. of CPUS:${NC}"
export cpus=`cat /proc/cpuinfo | grep processor | wc -l`
echo $cpus
echo "${Green}-----------------------------${NC}"
echo ""

echo "${BRed}${BRedU}Step1: Setup rootfs Environment${NC}"
echo ""
echo "${Green}-----------------------------"
echo "${Red}Check /home/$USER/rootfs folder:"
echo "${Green}-----------------------------${NC}"

if [ -d /home/$USER/rootfs ] ; then
        echo "${Red}/home/$USER/rootfs folder is found and remove folder${NC}"
	sudo rm -rf /home/$USER/rootfs
fi
        echo "${Purple} create a rootfs folder${NC}"
        sudo mkdir -p /home/$USER/rootfs/
	sudo chmod 4755 /home/$USER/rootfs/
	echo "${Purple}/home/$USER/rootfs folder successfully created.${NC}"

echo "${Green}-----------------------------"
echo "${Red}BusyBox Install"
echo "${Green}-----------------------------${NC}"
echo "${Purple}make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- CONFIG_PREFIX=/home/$USER/rootfs  install${NC} -j${cpus}"

cd busybox-1.31.1
sudo make ARCH=arm CROSS_COMPILE=/home/$USER/opt/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- CONFIG_PREFIX=/home/$USER/rootfs  install -j${cpus}

cd -

sudo cp -r rootfs/*  /home/$USER/rootfs

echo "${Purple}sudo tar xfvp ${KM_BBB_KERNEL}/out/*-dtbs.tar.gz  -C  /home/$USER/rootfs/boot/dtbs/${KERNEL_UTS}${NC}"

sudo mkdir -p  /home/$USER/rootfs/boot/dtbs/$KERNEL_UTS
sudo tar xfvp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}-dtbs.tar.gz  -C  /home/$USER/rootfs/boot/dtbs/${KERNEL_UTS}


echo "${Purple}cp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}.zImage /home/$USER/KM_GIT/KM-BBB-RFS/rootfs/boot/vmlinuz-${KERNEL_UTS}${NC}"
sudo cp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}.zImage  /home/$USER/rootfs/boot/vmlinuz-${KERNEL_UTS}


echo "${Purple}sudo tar xfvp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}-modules.tar.gz  -C  /home/$USER/rootfs${NC}"
sudo tar xfvp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}-modules.tar.gz  -C  /home/$USER/rootfs

sudo chown -R root /home/$USER/rootfs/lib
sudo chgrp -R root /home/$USER/rootfs/lib

#sudo mv /home/km/rootfs/lib/modules/4.19.94-Kernel-Masters-* /home/km/rootfs/lib/modules/4.19.94-Kernel-Masters
