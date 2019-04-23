#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=curl
URL=https://curl.haxx.se/download/curl-7.64.1.tar.xz
DESCRIPTION="The cURL package contains an utility and a library used for transferring files with URL syntax to any of the following protocols: FTP, FTPS, HTTP, HTTPS, SCP, SFTP, TFTP, TELNET, DICT, LDAP, LDAPS and FILE. Its ability to both download and upload files can be incorporated into other programs to support functions like streaming media."
VERSION=7.64.1

#REC:make-ca

cd $SOURCE_DIR

wget -nc https://curl.haxx.se/download/curl-7.64.1.tar.xz

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
--enable-threaded-resolver \
--with-ca-path=/etc/ssl/certs &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

rm -rf docs/examples/.deps &&

find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&

install -v -d -m755 /usr/share/doc/curl-7.64.1 &&
cp -v -R docs/* /usr/share/doc/curl-7.64.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
