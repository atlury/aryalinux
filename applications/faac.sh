#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" FAAC is an encoder for a lossy sound compression scheme specified in MPEG-2 Part 7 and MPEG-4 Part 3 standards and known as Advanced Audio Coding (AAC). This encoder is useful for producing files that can be played back on iPod. Moreover, iPod does not understand other sound compression schemes in video files."
SECTION="multimedia"
VERSION=1.29.9.2
NAME="faac"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/faac/faac-1.29.9.2.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/faac/faac-1.29.9.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/faac/faac-1.29.9.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/faac/faac-1.29.9.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/faac/faac-1.29.9.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/faac/faac-1.29.9.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/faac/faac-1.29.9.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/faac/faac-1.29.9.2.tar.gz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
