#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" This is a library that provides cross platform access to statistics about the system on which it's run. It's written in C and presents a selection of useful interfaces which can be used to access key system statistics. The current list of statistics includes CPU usage, memory utilisation, disk usage, process counts, network traffic, disk I/O, and more."
SECTION="general"
VERSION=0.91
NAME="libstatgrab"



cd $SOURCE_DIR

URL=http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libstatgrab/libstatgrab-0.91.tar.gz || wget -nc ftp://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz

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

./configure --prefix=/usr   \
            --disable-static \
            --docdir=/usr/share/doc/libstatgrab-0.91 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
