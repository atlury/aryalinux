#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=apache-maven
URL=http://mirrors.estointernet.in/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
DESCRIPTION="Maven is a build tool for Java. The maven tool makes building and packaging of Java applications easy by providing a neat command line tool which can easily build and package java applications for deployment."
VERSION=3.6.0


cd $SOURCE_DIR

wget -nc http://mirrors.estointernet.in/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz

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

sudo mkdir -pv /opt/mvn/
sudo mv * /opt/mvn/
sudo tee /etc/profile.d/mvn.sh << "EOF"
export PATH=$PATH:/opt/mvn/bin
export M2_HOME=/opt/mvn
EOF

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
