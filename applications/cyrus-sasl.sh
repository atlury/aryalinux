#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=cyrus-sasl
URL=https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.27/cyrus-sasl-2.1.27.tar.gz
DESCRIPTION="The Cyrus SASL package contains a Simple Authentication and Security Layer, a method for adding authentication support to connection-based protocols. To use SASL, a protocol includes a command for identifying and authenticating a user to a server and for optionally negotiating protection of subsequent protocol interactions. If its use is negotiated, a security layer is inserted between the protocol and the connection."
VERSION=2.1.27

#REC:db

cd $SOURCE_DIR

wget -nc https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.27/cyrus-sasl-2.1.27.tar.gz
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2

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
--sysconfdir=/etc \
--enable-auth-sasldb \
--with-dbpath=/var/lib/sasl/sasldb2 \
--with-saslauthd=/var/run/saslauthd &&
make -j1

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -dm755 /usr/share/doc/cyrus-sasl-2.1.27/html &&
install -v -m644 saslauthd/LDAP_SASLAUTHD /usr/share/doc/cyrus-sasl-2.1.27 &&
install -v -m644 doc/html/*.html /usr/share/doc/cyrus-sasl-2.1.27/html &&
install -v -dm700 /var/lib/sasl
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar -xf blfs-systemd-units-20180105.tar.bz2
pushd blfs-systemd-units-20180105
sudo make install-saslauthd
popd
popd
sudo rm -rf $SOURCE_DIR/blfs-systemd-units-20180105

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
