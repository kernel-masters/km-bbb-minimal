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
echo  "KERNEL_UTS:$KERNEL_UTS"

#echo "Busy Box defconfig"

echo "${Green}-----------------------------"
echo -n ${Red}"Check No. of CPUS:${NC}"
export cpus=`cat /proc/cpuinfo | grep processor | wc -l`
echo $cpus
echo "${Green}-----------------------------${NC}"
echo ""

echo "${BRed}${BRedU}Step1: Setup rootfs Environment${NC}"
echo ""

if [ -d rootfs/proc ] ; then
        echo "${Red} rootfs/proc folder is found${NC}"
else
        echo "${Purple} create a /proc folder${NC}"
        mkdir -p rootfs/proc
	echo "${Purple}rootfs/proc folder successfully created.${NC}"
fi
if [ -d rootfs/sys ] ; then
        echo "${Red} rootfs/sys folder is found${NC}"
else
        echo "${Purple} create a /sys folder${NC}"
        mkdir -p rootfs/sys
	echo "${Purple}rootfs/sys folder successfully created.${NC}"
fi

if [ -d rootfs/dev ] ; then
        echo "${Red} rootfs/dev folder is found${NC}"
else
        echo "${Purple} create a /dev folder${NC}"
        mkdir -p rootfs/dev
	echo "${Purple}rootfs/dev folder successfully created.${NC}"
fi

if [ -d rootfs/debug ] ; then
        echo "${Red} rootfs/debug folder is found${NC}"
else
        echo "${Purple} create a /debug folder${NC}"
        mkdir -p rootfs/debug
	echo "${Purple}rootfs/debug folder successfully created.${NC}"
fi

echo "${Green}-----------------------------"
echo "${Red}BusyBox Install"
echo "${Green}-----------------------------${NC}"
echo "${Purple}make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- CONFIG_PREFIX=/home/$USER/rootfs  install${NC} -j${cpus}"

cd busybox-1.31.1
make ARCH=arm CROSS_COMPILE=/home/$USER/opt/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- CONFIG_PREFIX=../rootfs  install -j${cpus}

cd -

echo "${Purple}tar xfvp ${KM_BBB_KERNEL}/out/*-dtbs.tar.gz  -C  rootfs/boot/dtbs/${KERNEL_UTS}${NC}"

mkdir -p  rootfs/boot/dtbs/$KERNEL_UTS
tar xfvp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}-dtbs.tar.gz  -C  rootfs/boot/dtbs/${KERNEL_UTS}


echo "${Purple}cp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}.zImage rootfs/boot/vmlinuz-${KERNEL_UTS}${NC}"
cp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}.zImage  rootfs/boot/vmlinuz-${KERNEL_UTS}


echo "${Purple}cp ${KM_BBB_KERNEL}/out/uEnv.txt rootfs/boot ${NC}"
cp  ${KM_BBB_KERNEL}/out/uEnv.txt rootfs/boot/uEnv.txt

echo "${Purple} tar xfvp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}-modules.tar.gz  -C  rootfs${NC}"
tar xfvp ${KM_BBB_KERNEL}/out/${KERNEL_UTS}-modules.tar.gz  -C  rootfs

cd rootfs/
tar cvf minimal-rootfs-1.1.tar .
tar czvf ../minimal-rootfs-1.1.tar.gz minimal-rootfs-1.1.tar
rm minimal-rootfs-1.1.tar
cd -

#sudo chown -R root rootfs/lib
#sudo chgrp -R root rootfs/lib


#mv /home/km/rootfs/lib/modules/4.19.94-Kernel-Masters-* /home/km/rootfs/lib/modules/4.19.94-Kernel-Masters
