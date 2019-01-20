#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc ftp://ftp.isc.org/isc/dhcp/4.4.1/dhcp-4.4.1.tar.gz

NAME=dhcp
VERSION=4.4.1
URL=ftp://ftp.isc.org/isc/dhcp/4.4.1/dhcp-4.4.1.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

( export CFLAGS="$CFLAGS -Wall -fno-strict-aliasing \
-D_PATH_DHCLIENT_SCRIPT='\"/sbin/dhclient-script\"' \
-D_PATH_DHCPD_CONF='\"/etc/dhcp/dhcpd.conf\"' \
-D_PATH_DHCLIENT_CONF='\"/etc/dhcp/dhclient.conf\"'" &&

./configure --prefix=/usr \
--sysconfdir=/etc/dhcp \
--localstatedir=/var \
--with-srv-lease-file=/var/lib/dhcpd/dhcpd.leases \
--with-srv6-lease-file=/var/lib/dhcpd/dhcpd6.leases \
--with-cli-lease-file=/var/lib/dhclient/dhclient.leases \
--with-cli6-lease-file=/var/lib/dhclient/dhclient6.leases
) &&
make -j1

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C client install &&
mv -v /usr/sbin/dhclient /sbin &&
install -v -m755 client/scripts/linux /sbin/dhclient-script
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C server install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
mv -v /usr/sbin/dhclient /sbin &&
install -v -m755 client/scripts/linux /sbin/dhclient-script
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm755 /etc/dhcp &&
cat > /etc/dhcp/dhclient.conf << "EOF"
# Begin /etc/dhcp/dhclient.conf
#
# Basic dhclient.conf(5)

#prepend domain-name-servers 127.0.0.1;
request subnet-mask, broadcast-address, time-offset, routers,
domain-name, domain-name-servers, domain-search, host-name,
netbios-name-servers, netbios-scope, interface-mtu,
ntp-servers;
require subnet-mask, domain-name-servers;
#timeout 60;
#retry 60;
#reboot 10;
#select-timeout 5;
#initial-interval 2;

# End /etc/dhcp/dhclient.conf
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm 755 /var/lib/dhclient
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-dhclient
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/dhcp/dhcpd.conf << "EOF"
# Begin /etc/dhcp/dhcpd.conf
#
# Example dhcpd.conf(5)

# Use this to enble / disable dynamic dns updates globally.
ddns-update-style none;

# option definitions common to all supported networks...
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

# This is a very basic subnet declaration.
subnet 10.254.239.0 netmask 255.255.255.224 {
range 10.254.239.10 10.254.239.20;
option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
}

# End /etc/dhcp/dhcpd.conf
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm 755 /var/lib/dhcpd
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar -xf blfs-systemd-units-20180105.tar.bz2
pushd blfs-systemd-units-20180105
sudo make install-dhcpd
popd
popd
sudo rm -rf $SOURCE_DIR/blfs-systemd-units-20180105


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
