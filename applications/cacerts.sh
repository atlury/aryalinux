#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=cacerts
URL=
DESCRIPTION="Public Key Infrastructure (PKI) is a method to validate the authenticity of an otherwise unknown entity across untrusted networks. PKI works by establishing a chain of trust, rather than trusting each individual host or entity explicitly. In order for a certificate presented by a remote entity to be trusted, that certificate must present a complete chain of certificates that can be validated using the root certificate of a Certificate Authority (CA) that is trusted by the local machine"
VERSION=latest

#REQ:openssl10
#OPT:java
#OPT:openjdk
#OPT:nss

cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/other/make-ca.sh-20161126
wget -nc http://anduin.linuxfromscratch.org/BLFS/other/certdata.txt

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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
