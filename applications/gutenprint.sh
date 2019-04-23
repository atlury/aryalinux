#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gutenprint
URL=https://downloads.sourceforge.net/gimp-print/gutenprint-5.2.14.tar.bz2
DESCRIPTION="The Gutenprint (formerly Gimp-Print) package contains high quality drivers for many brands and models of printers for use with <a class=\xref\ href=\cups.html\ title=\Cups-2.2.7\>Cups-2.2.7</a> and the GIMP-2.0. See a list of supported printers at <a class=\ulink\ href=\http://gutenprint.sourceforge.net/p_Supported_Printers.php\>http://gutenprint.sourceforge.net/p_Supported_Printers.php</a>."
VERSION=5.2.14

#REC:cups
#REC:gimp

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/gimp-print/gutenprint-5.2.14.tar.bz2

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

sed -i 's|$(PACKAGE)/doc|doc/$(PACKAGE)-$(VERSION)|' \
{,doc/,doc/developer/}Makefile.in &&

./configure --prefix=/usr --disable-static &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/gutenprint-5.2.14/api/gutenprint{,ui2} &&
install -v -m644 doc/gutenprint/html/* \
/usr/share/doc/gutenprint-5.2.14/api/gutenprint &&
install -v -m644 doc/gutenprintui2/html/* \
/usr/share/doc/gutenprint-5.2.14/api/gutenprintui2
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl restart org.cups.cupsd
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
