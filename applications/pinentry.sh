#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=pinentry
URL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.1.0.tar.bz2
DESCRIPTION="The PIN-Entry package contains a collection of simple PIN or pass-phrase entry dialogs which utilize the Assuan protocol as described by the aegypten project. PIN-Entry programs are usually invoked by the gpg-agent daemon, but can be run from the command line as well. There are programs for various text-based and GUI environments, including interfaces designed for Ncurses (text-based), and for the common GTK and Qt toolkits."
VERSION=1.1.0

#REQ:libassuan
#REQ:libgpg-error

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.1.0.tar.bz2

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

./configure --prefix=/usr --enable-pinentry-tty &&
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
