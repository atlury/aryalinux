#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lm_sensors
URL=https://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2
DESCRIPTION="The lm_sensors package provides user-space support for the hardware monitoring drivers in the Linux kernel. This is useful for monitoring the temperature of the CPU and adjusting the performance of some hardware (such as cooling fans)."
VERSION=3.4.0

#REQ:which

cd $SOURCE_DIR

wget -nc https://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2
wget -nc ftp://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2

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

make PREFIX=/usr \
BUILD_STATIC_LIB=0 \
MANDIR=/usr/share/man

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr \
BUILD_STATIC_LIB=0 \
MANDIR=/usr/share/man install &&

install -v -m755 -d /usr/share/doc/lm_sensors-3.4.0 &&
cp -rv README INSTALL doc/* \
/usr/share/doc/lm_sensors-3.4.0
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
