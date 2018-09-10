#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Doxygen package contains a documentation system for C++, C, Java, Objective-C, Corba IDL and to some extent PHP, C# and D. It is useful for generating HTML documentation and/or an off-line reference manual from a set of documented source files. There is also support for generating output in RTF, PostScript, hyperlinked PDF, compressed HTML, and Unix man pages. The documentation is extracted directly from the sources, which makes it much easier to keep the documentation consistent with the source code."
SECTION="general"
VERSION=1.8.14
NAME="doxygen"

#REQ:cmake
#OPT:graphviz
#OPT:gs
#OPT:libxml2
#OPT:llvm
#OPT:python2
#OPT:qt5
#OPT:texlive
#OPT:tl-installer
#OPT:xapian


cd $SOURCE_DIR

URL=http://ftp.stack.nl/pub/doxygen/doxygen-1.8.14.src.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.stack.nl/pub/doxygen/doxygen-1.8.14.src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/doxygen/doxygen-1.8.14.src.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/doxygen/doxygen-1.8.14.src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/doxygen/doxygen-1.8.14.src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/doxygen/doxygen-1.8.14.src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/doxygen/doxygen-1.8.14.src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/doxygen/doxygen-1.8.14.src.tar.gz || wget -nc ftp://ftp.stack.nl/pub/doxygen/doxygen-1.8.14.src.tar.gz

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

mkdir -v build &&
cd       build &&
cmake -G "Unix Makefiles"         \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -Wno-dev .. &&
make "-j`nproc`" || make


cmake -DDOC_INSTALL_DIR=share/doc/doxygen-1.8.14 -Dbuild_doc=ON .. &&
make docs



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -vm644 ../doc/*.1 /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
