#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnumeric
URL=http://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.44.tar.xz
DESCRIPTION="The Gnumeric package contains a spreadsheet program which is useful for mathematical analysis."
VERSION=1.12.44

#REQ:goffice010
#REQ:itstool
#REQ:rarian
#REC:adwaita-icon-theme
#REC:oxygen-icons5
#REC:gnome-icon-theme
#REC:yelp

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.44.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.44.tar.xz

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

sed -i 's/HELP_LINGUAS = cs de es/HELP_LINGUAS = de es/' doc/Makefile.in &&
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
