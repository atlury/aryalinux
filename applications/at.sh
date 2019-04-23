#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=at
URL=http://ftp.debian.org/debian/pool/main/a/at/at_3.1.23.orig.tar.gz
DESCRIPTION="The at package provide delayed job execution and batch processing. It is required for Linux Standards Base (LSB) conformance."
VERSION=at_3.1.23.orig

#REQ:mail

cd $SOURCE_DIR

wget -nc http://ftp.debian.org/debian/pool/main/a/at/at_3.1.23.orig.tar.gz

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
groupadd -g 17 atd &&
useradd -d /dev/null -c "atd daemon" -g atd -s /bin/false -u 17 atd &&
mkdir -p /var/spool/cron
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sed -i '/docdir/s/=.*/= @docdir@/' Makefile.in
autoreconf
./configure --with-daemon_username=atd \
--with-daemon_groupname=atd \
SENDMAIL=/usr/sbin/sendmail \
--with-systemdsystemunitdir=/lib/systemd/system &&
make -j1

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install docdir=/usr/share/doc/at-3.1.23 \
atdocdir=/usr/share/doc/at-3.1.23
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable atd
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
