#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=nspr
URL=https://archive.mozilla.org/pub/nspr/releases/v4.21/src/nspr-4.21.tar.gz
DESCRIPTION="Netscape Portable Runtime (NSPR) provides a platform-neutral API for system level and libc like functions."
VERSION=4.21


cd $SOURCE_DIR

wget -nc https://archive.mozilla.org/pub/nspr/releases/v4.21/src/nspr-4.21.tar.gz

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

cd nspr &&
sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in &&
sed -i 's#$(LIBRARY) ##' config/rules.mk &&

./configure --prefix=/usr \
--with-mozilla \
--with-pthreads \
$([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
