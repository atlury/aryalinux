#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lxdm
URL=https://downloads.sourceforge.net/lxdm/lxdm-0.5.3.tar.xz
DESCRIPTION="The LXDM is a lightweight Display Manager for the LXDE desktop. It can also be used as an alternative to other Display Managers such as GNOME's GDM or LightDM."
VERSION=0.5.3

#REQ:gtk2
#REQ:iso-codes
#REQ:librsvg
#REC:linux-pam

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/lxdm/lxdm-0.5.3.tar.xz

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY

whoami > /tmp/currentuser

# BUILD COMMANDS START HERE

export XORG_PREFIX=/usr

cat > pam/lxdm << "EOF"
# Begin /etc/pam.d/lxdm

auth requisite pam_nologin.so
auth required pam_env.so
auth include system-auth

account include system-account

password include system-password

session required pam_limits.so
session include system-session

# End /etc/pam.d/lxdm
EOF

sed -i 's:sysconfig/i18n:profile.d/i18n.sh:g' data/lxdm.in &&
sed -i 's:/etc/xprofile:/etc/profile:g' data/Xsession &&
sed -e 's/^bg/#&/' \
-e '/reset=1/ s/# //' \
-e 's/logou$/logout/' \
-e "/arg=/a arg=$XORG_PREFIX/bin/X" \
-i data/lxdm.conf.in
./configure --prefix=/usr \
--sysconfdir=/etc \
--with-pam \
--with-systemdsystemunitdir=/lib/systemd/system &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable lxdm
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
