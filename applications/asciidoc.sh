#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Asciidoc package is a text document format for writing notes, documentation, articles, books, ebooks, slideshows, web pages, man pages and blogs. AsciiDoc files can be translated to many formats including HTML, PDF, EPUB, and man page."
SECTION="general"
VERSION=8.6.9
NAME="asciidoc"

#OPT:python2


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/asciidoc/asciidoc-8.6.9.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/asciidoc-8.6.9 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
make docs

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
