#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=goffice010
URL=http://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.44.tar.xz
DESCRIPTION="The GOffice package contains a library of GLib/GTK document centric objects and utilities. This is useful for performing common operations for document centric applications that are conceptually simple, but complex to implement fully. Some of the operations provided by the GOffice library include support for plugins, load/save routines for application documents and undo/redo functions."
VERSION=0.10.44

#REQ:gtk3
#REQ:libgsf
#REQ:librsvg
#REQ:libxslt
#REQ:which

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.44.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.44.tar.xz

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
