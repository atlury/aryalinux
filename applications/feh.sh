#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=feh
URL=http://feh.finalrewind.org/feh-3.1.3.tar.bz2
DESCRIPTION="feh is a fast, lightweight image viewer which uses Imlib2. It is commandline-driven and supports multiple images through slideshows, thumbnail browsing or multiple windows, and montages or index prints (using TrueType fonts to display file info). Advanced features include fast dynamic zooming, progressive loading, loading via HTTP (with reload support for watching webcams), recursive file opening (slideshow of a directory hierarchy), and mouse wheel/keyboard control."
VERSION=3.1.3

#REQ:libpng
#REQ:imlib2
#REQ:giflib
#REC:curl

cd $SOURCE_DIR

wget -nc http://feh.finalrewind.org/feh-3.1.3.tar.bz2

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

sed -i "s:doc/feh:&-3.1.3:" config.mk &&
make PREFIX=/usr

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
