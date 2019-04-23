#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=newt
URL=https://releases.pagure.org/newt/newt-0.52.20.tar.gz
DESCRIPTION="Newt is a programming library for color text mode, widget based user interfaces. It can be used to add stacked windows, entry widgets, checkboxes, radio buttons, labels, plain text fields, scrollbars, etc., to text mode user interfaces. Newt is based on the S-Lang library."
VERSION=0.52.20

#REQ:popt
#REQ:slang
#REC:tcl
#REC:gpm

cd $SOURCE_DIR

wget -nc https://releases.pagure.org/newt/newt-0.52.20.tar.gz

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

sed -e 's/^LIBNEWT =/#&/' \
-e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
-e 's/$(LIBNEWT)/$(LIBNEWTSONAME)/g' \
-i Makefile.in &&

./configure --prefix=/usr --with-gpm-support &&
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
