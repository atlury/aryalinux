#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=cups-filters
URL=https://www.openprinting.org/download/cups-filters/cups-filters-1.22.3.tar.xz
DESCRIPTION="The CUPS Filters package contains backends, filters and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc."
VERSION=1.22.3

#REQ:cups
#REQ:glib2
#REQ:gs
#REQ:lcms2
#REQ:poppler
#REQ:qpdf
#REC:libjpeg
#REC:libpng
#REC:libtiff
#REC:mupdf

cd $SOURCE_DIR

wget -nc https://www.openprinting.org/download/cups-filters/cups-filters-1.22.3.tar.xz

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

sed -i "s:cups.service:org.cups.cupsd.service:g" utils/cups-browsed.service
./configure --prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--without-rcdir \
--disable-static \
--disable-avahi \
--docdir=/usr/share/doc/cups-filters-1.22.3 &&
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
install -v -m644 utils/cups-browsed.service /lib/systemd/system/cups-browsed.service
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable cups-browsed
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
