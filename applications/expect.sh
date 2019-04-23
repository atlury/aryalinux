#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=expect
URL=https://downloads.sourceforge.net/expect/expect5.45.4.tar.gz
DESCRIPTION="The Expect package was installed in the LFS temporary tools directory for testing other packages. These procedures install it in a permanent location. It contains tools for automating interactive applications such as <span class=\command\><strong>telnet</strong>, <span class=\command\><strong>ftp</strong>, <span class=\command\><strong>passwd</strong>, <span class=\command\><strong>fsck</strong>, <span class=\command\><strong>rlogin</strong>, <span class=\command\><strong>tip</strong>, etc. Expect is also useful for testing these same applications as well as easing all sorts of tasks that are prohibitively difficult with anything else."
VERSION=expect5.45.4

#REQ:tcl

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/expect/expect5.45.4.tar.gz

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

./configure --prefix=/usr \
--with-tcl=/usr/lib \
--enable-shared \
--mandir=/usr/share/man \
--with-tclinclude=/usr/include &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
