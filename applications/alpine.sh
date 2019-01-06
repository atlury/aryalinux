#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:openldap
#OPT:mitkrb
#OPT:aspell
#OPT:tcl
#OPT:linux-pam

cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/alpine/alpine-2.21.tar.xz

NAME=alpine
VERSION=2.21
URL=http://anduin.linuxfromscratch.org/BLFS/alpine/alpine-2.21.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

LIBS+="-lcrypto" ./configure --prefix=/usr \
--sysconfdir=/etc \
--without-ldap \
--without-krb5 \
--without-pam \
--without-tcl \
--with-ssl-dir=/usr \
--with-passfile=.pine-passfile &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
