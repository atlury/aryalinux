#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=dejagnu
URL=https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.2.tar.gz
DESCRIPTION="DejaGnu is a framework for running test suites on GNU tools. It is written in <span class=\command\><strong>expect</strong>, which uses Tcl (Tool command language). It was installed by LFS in the temporary <code class=\filename\>/tools directory. These instructions install it permanently."
VERSION=1.6.2

#REQ:expect

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.2.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.2.tar.gz

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

./configure --prefix=/usr &&
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi &&
makeinfo --plaintext -o doc/dejagnu.txt doc/dejagnu.texi

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -dm755 /usr/share/doc/dejagnu-1.6.2 &&
install -v -m644 doc/dejagnu.{html,txt} \
/usr/share/doc/dejagnu-1.6.2
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
