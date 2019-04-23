#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=procmail
URL=http://ftp.osuosl.org/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz
DESCRIPTION="The Procmail package contains an autonomous mail processor. This is useful for filtering and sorting incoming mail."
VERSION=3.22

#REC:mail

cd $SOURCE_DIR

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/procmail-3.22-consolidated_fixes-1.patch

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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -i 's/getline/get_line/' src/*.[ch] &&
patch -Np1 -i ../procmail-3.22-consolidated_fixes-1.patch &&

make LOCKINGTEST=/tmp MANDIR=/usr/share/man install &&
make install-suid
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
