#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=fetchmail
URL=https://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz
DESCRIPTION="The Fetchmail package contains a mail retrieval program. It retrieves mail from remote mail servers and forwards it to the local (client) machine's delivery system, so it can then be read by normal mail user agents."
VERSION=6.3.26

#REC:procmail

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/fetchmail-6.3.26-disable_sslv3-1.patch

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

patch -Np1 -i ../fetchmail-6.3.26-disable_sslv3-1.patch &&
./configure --prefix=/usr --with-ssl --enable-fallback=procmail &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > ~/.fetchmailrc << "EOF"
set logfile /var/log/fetchmail.log
set no bouncemail
set postmaster root

poll SERVERNAME :
user <em class="replaceable"><code><username></em> pass <em class="replaceable"><code><password></em>;
mda "/usr/bin/procmail -f %F -d %T";
EOF

chmod -v 0600 ~/.fetchmailrc

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
