#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=rest
URL=http://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.1.tar.xz
DESCRIPTION="The rest package contains a library that was designed to make it easier to access web services that claim to be \RESTful\. It includes convenience wrappers for libsoup and libxml to ease remote use of the RESTful API."
VERSION=0.8.1

#REQ:make-ca
#REQ:libsoup
#REC:gobject-introspection

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.1.tar.xz

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
--with-ca-certificates=/etc/pki/tls/certs/ca-bundle.crt &&
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
