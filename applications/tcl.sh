#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/tcl/tcl8.6.10-src.tar.gz
wget -nc https://downloads.sourceforge.net/tcl/tcl8.6.10-html.tar.gz


NAME=tcl
VERSION=
URL=https://downloads.sourceforge.net/tcl/tcl8.6.10-src.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


tar -xf ../tcl8.6.10-html.tar.gz --strip-components=1
export SRCDIR=`pwd` &&

cd unix &&

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make &&

sed -e "s#$SRCDIR/unix#/usr/lib#" \
    -e "s#$SRCDIR#/usr/include#"  \
    -i tclConfig.sh               &&

sed -e "s#$SRCDIR/unix/pkgs/tdbc1.1.1#/usr/lib/tdbc1.1.1#" \
    -e "s#$SRCDIR/pkgs/tdbc1.1.1/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/tdbc1.1.1/library#/usr/lib/tcl8.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.1.1#/usr/include#"            \
    -i pkgs/tdbc1.1.1/tdbcConfig.sh                        &&

sed -e "s#$SRCDIR/unix/pkgs/itcl4.2.0#/usr/lib/itcl4.2.0#" \
    -e "s#$SRCDIR/pkgs/itcl4.2.0/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/itcl4.2.0#/usr/include#"            \
    -i pkgs/itcl4.2.0/itclConfig.sh                        &&

unset SRCDIR
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
make install-private-headers &&
ln -v -sf tclsh8.6 /usr/bin/tclsh &&
chmod -v 755 /usr/lib/libtcl8.6.so
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mkdir -v -p /usr/share/doc/tcl-8.6.10 &&
cp -v -r  ../html/* /usr/share/doc/tcl-8.6.10
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

