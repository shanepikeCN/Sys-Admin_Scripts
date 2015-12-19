#! /bin/bash

if [[ $(id -u) != 0 ]]; then # Checks if the user is root
	echo "Script must be executed as root."
	#exit 1

fi
 
 #sed -i 's/SELINUX\=enforcing/SELINUX\=disabled/g' /etc/selinux/config #Modify the SeLinux settings
 #service firewalld stop # Turn off the firewall
 #systemctl disable firewalld  # Disable the firewall service so it doesn't restaur
 #yum install -y epel-release # Install extra packages repository

 # Install packages for DHCP and TFTP server, and cobbler/kickstart
 #yum install -y cobbler cobbler-web pykickstart system-config-kickstart dhcp mod_python wget TFTP rsync

#Some changes to xinetd the super service
#systemctl start cobblerd
#systemctl enable cobblerd

#Modifying Cobbler DHCP settings. Change here for own environment
sed -i 's/server\:\ 192\.168\.7\.2/server\:\ 10\.200\.2\.244/g' /etc/cobbler/settings
sed -i 's/default\_password\_crypted\:\ \"\$1\$mF86\/UHC\$WvcIcX2t6crBz2onWxyac\.\"/default\_password\_crypted\:\ \"\$1\$centosho\$05Gidn0z8BjDu2ZbV4fS\.0\"/g' /etc/cobbler/settings
sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings

sed -i 's/module = authn_denyall/module = authn_configfile/g' /etc/cobbler/modules.conf

htdigest /etc/cobbler/users.digest "Cobbler" cobbler # Create cobler user

cd /root
wget http://mirrors.opencas.cn/centos/6.7/isos/x86_64/CentOS-6.7-x86_64-bin-DVD1.iso #Download Centos 6.5 file