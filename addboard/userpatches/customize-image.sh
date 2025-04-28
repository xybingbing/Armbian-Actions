#!/bin/bash

# arguments: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
#
# This is the image customization script

# NOTE: It is copied to /tmp directory inside the image
# and executed there inside chroot environment
# so don't reference any files that are not already installed

# NOTE: If you want to transfer files between chroot and host
# userpatches/overlay directory on host is bind-mounted to /tmp/overlay in chroot
# The sd card's root path is accessible via $SDCARD variable.

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4

# Disable update kernel
mkdir -p /etc/apt/preferences.d
DISABLE_UPDATE_CONF=/etc/apt/preferences.d/disable-update
PKG_LIST=$(dpkg-query --show --showformat='${Package}\n')

function DISABLE_UPDATE() {
    echo -e "Package: $1\nPin: version *\nPin-Priority: -1\n" >> ${DISABLE_UPDATE_CONF}
}

cat /dev/null > ${DISABLE_UPDATE_CONF}
DISABLE_UPDATE armbian-firmware
DISABLE_UPDATE $(echo "${PKG_LIST}" | grep "armbian-bsp-cli-")
DISABLE_UPDATE $(echo "${PKG_LIST}" | grep "^linux-image-")
DISABLE_UPDATE $(echo "${PKG_LIST}" | grep "^linux-dtb-")
DISABLE_UPDATE $(echo "${PKG_LIST}" | grep "^linux-u-boot")

sed -i 's/Armbian-unofficial/Armbian OS/g' /etc/armbian-image-release
sed -i 's/Armbian-unofficial/Armbian OS/g' /etc/armbian-release
#设置主机名
echo "rk3399" | sudo tee /etc/hostname