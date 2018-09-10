#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" Lynx is a text based web browser."
SECTION="basicnet"
VERSION=.2
NAME="lynx"

#OPT:gnutls
#OPT:zip
#OPT:unzip
#OPT:sharutils


cd $SOURCE_DIR

URL=http://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.8rel.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.8rel.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lynx/lynx2.8.8rel.2.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/lynx-2.8.8rel.2-openssl_1.1.0-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/lynx/lynx-2.8.8rel.2-openssl_1.1.0-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/lynx-2.8.8rel.2-ncurses_6.1-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/lynx/lynx-2.8.8rel.2-ncurses_6.1-1.patch

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

patch -p1 -i ../lynx-2.8.8rel.2-openssl_1.1.0-1.patch


patch -p1 -i ../lynx-2.8.8rel.2-ncurses_6.1-1.patch


./configure --prefix=/usr          \
            --sysconfdir=/etc/lynx \
            --datadir=/usr/share/doc/lynx-2.8.8rel.2 \
            --with-zlib            \
            --with-bzlib           \
            --with-ssl             \
            --with-screen=ncursesw \
            --enable-locale-charset &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install-full &&
chgrp -v -R root /usr/share/doc/lynx-2.8.8rel.2/lynx_doc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#LOCALE/     a LOCALE_CHARSET:TRUE'     \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#DEFAULT_ED/ a DEFAULT_EDITOR:vi'       \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/#PERSIST/    a PERSISTENT_COOKIES:TRUE' \
    -i /etc/lynx/lynx.cfg

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
