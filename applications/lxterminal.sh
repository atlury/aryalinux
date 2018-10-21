#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LXTerminal package contains abr3ak VTE-based terminal emulator for LXDE with support for multiple tabs.br3ak"
SECTION="lxde"
VERSION=0.3.1
NAME="lxterminal"

#REQ:vte2
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lxde/lxterminal-0.3.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lxde/lxterminal-0.3.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxterminal/lxterminal-0.3.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxterminal/lxterminal-0.3.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxterminal/lxterminal-0.3.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxterminal/lxterminal-0.3.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxterminal/lxterminal-0.3.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxterminal/lxterminal-0.3.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -ri '/^ +init/s/init/return init/' src/unixsocket.c &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"