#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The GC package contains the Boehm-Demers-Weiser conservative garbage collector, which can be used as a garbage collecting replacement for the C malloc function or C++ new operator. It allows you to allocate memory basically as you normally would, without explicitly deallocating memory that is no longer useful. The collector automatically recycles memory when it determines that it can no longer be otherwise accessed. The collector is also used by a number of programming language implementations that either use C as intermediate code, want to facilitate easier interoperation with C libraries, or just prefer the simple collector interface. Alternatively, the garbage collector may be used as a leak detector for C or C++ programs, though that is not its primary goal."
SECTION="general"
VERSION=7.6.4
NAME="gc"

#REQ:libatomic_ops


cd $SOURCE_DIR

URL=http://www.hboehm.info/gc/gc_source/gc-7.6.4.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.hboehm.info/gc/gc_source/gc-7.6.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gc/gc-7.6.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gc/gc-7.6.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gc/gc-7.6.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gc/gc-7.6.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gc/gc-7.6.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gc/gc-7.6.4.tar.gz

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

./configure --prefix=/usr      \
            --enable-cplusplus \
            --disable-static   \
            --docdir=/usr/share/doc/gc-7.6.4 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 doc/gc.man /usr/share/man/man3/gc_malloc.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
