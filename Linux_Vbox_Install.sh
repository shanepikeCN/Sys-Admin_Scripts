#! /bin/bash
# Script will set up and install necessary items to run VirtualBox on REHL 7. Ensure system
# is restarted as VirtualBox will not work without the Kernel settings properly configured.

yum update
echo "--- System will need to be restarted if the current Kernel is upgraded ---"
rpm -Uvh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/7/x86_64/e/epel-release-7-5.noarch.rpm # Installing extra packages repo for Centos 7
yum install -y kernel-devel kernel-headers dkms
# Downloading the Oracle public key
wget http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc
rpm --import oracle_vbox.asc
# Downloading the virtual box repository and adding it to the YUM repo's folder
wget http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo
# Configuring kernel sources for the virtualbox installation for current Kernel	
export KERN_DIR=/usr/src/kernels/$(uname -r)
yum install VirtualBox-5.0 -y # Installs the latest VirtualBox 
 # Set up rebuilds the Kernel modules
echo "Remember to run VB headless with virtualbox &"