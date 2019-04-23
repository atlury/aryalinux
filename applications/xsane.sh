#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xsane
URL=http://anduin.linuxfromscratch.org/BLFS/xsane/xsane-0.999.tar.gz
DESCRIPTION="XSane is another front end for <a class=\xref\ href=\sane.html\ title=\SANE-1.0.27\>SANE-1.0.27</a>. It has additional features to improve the image quality and ease of use compared to <span class=\command\><strong>xscanimage</strong>."
VERSION=0.999

#REQ:gtk2
#REQ:sane

cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/xsane/xsane-0.999.tar.gz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/xsane/xsane-0.999.tar.gz

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

sed -i -e 's/png_ptr->jmpbuf/png_jmpbuf(png_ptr)/' src/xsane-save.c &&
./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make xsanedocdir=/usr/share/doc/xsane-0.999 install &&
ln -v -s ../../doc/xsane-0.999 /usr/share/sane/xsane/doc
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -v -s <browser> /usr/bin/netscape
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -v -s /usr/bin/xsane /usr/lib/gimp/2.0/plug-ins/
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
