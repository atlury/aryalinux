#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" libisoburn is a frontend for libraries libburn and libisofs which enables creation and expansion of ISO-9660 filesystems on all CD/DVD/BD media supported by libburn. This includes media like DVD+RW, which do not support multi-session management on media level and even plain disk files or block devices."
SECTION="multimedia"
VERSION=1.4.8
NAME="libisoburn"

#REQ:libburn
#REQ:libisofs


cd $SOURCE_DIR

URL=http://files.libburnia-project.org/releases/libisoburn-1.4.8.tar.gz

if [ ! -z $URL ]
then
wget -nc http://files.libburnia-project.org/releases/libisoburn-1.4.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libisoburn/libisoburn-1.4.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libisoburn/libisoburn-1.4.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libisoburn/libisoburn-1.4.8.tar.gz

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

./configure --prefix=/usr              \
            --disable-static           \
            --enable-pkg-check-modules &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
