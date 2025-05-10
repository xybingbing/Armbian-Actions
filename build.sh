#!/bin/bash
#echo "安装环境"
#sudo apt update
#sudo apt install -y git gnupg flex bison build-essential zip curl zlib1g-dev \
#libc6-dev-i386 libncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev \
#libgl1-mesa-dev libxml2-utils xsltproc unzip bc python3 python3-distutils
echo "--------------------------------"
sudo rm -rf /data
sudo mkdir -p /data
sudo chown $USER:$GROUPS /data
sudo rm -rf workdir
sudo mkdir -p workdir
sudo chown $USER:$GROUPS workdir
cd workdir
WORKDIR=$(pwd)
echo "获取armbian源码"
#获取armbian
git clone --depth=1 https://github.com/armbian/build build
ln -sf $WORKDIR/build /data/build
cd /data/build
# 复制 config 和 userpatches 目录文件
cp -rf ${WORKDIR}/../addboard/config/* config
mkdir -p userpatches
cp -rf ${WORKDIR}/../addboard/userpatches/* userpatches
ls -la
echo "--------------------------------"
echo "编译镜像"
#./compile.sh build BOARD=edge-force BRANCH=stable BUILD_DESKTOP=no BUILD_MINIMAL=yes KERNEL_CONFIGURE=no RELEASE=jammy
./compile.sh build BOARD=nanopi-r5c BRANCH=stable BUILD_DESKTOP=no BUILD_MINIMAL=yes KERNEL_CONFIGURE=no RELEASE=jammy
echo "--------------------------------"
echo "保存镜像"
cp -rf output/images  ${WORKDIR}/../output