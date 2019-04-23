#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=subversion
URL=https://archive.apache.org/dist/subversion/subversion-1.11.1.tar.bz2
DESCRIPTION="Subversion is a version control system that is designed to be a compelling replacement for CVS in the open source community. It extends and enhances CVS' feature set, while maintaining a similar interface for those already familiar with CVS. These instructions install the client and server software used to manipulate a Subversion repository. Creation of a repository is covered at <a class=\xref\  href=\svnserver.html\ title=\Running a Subversion Server\>Running a Subversion Server</a>."
VERSION=1.11.1

#REQ:apr-util
#REQ:sqlite
#REC:serf

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/subversion/subversion-1.11.1.tar.bz2

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
--disable-static \
--with-apache-libexecdir \
--with-lz4=internal \
--with-utf8proc=internal &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/subversion-1.11.1 &&
cp -v -R doc/* \
/usr/share/doc/subversion-1.11.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
