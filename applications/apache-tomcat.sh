#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=apache-tomcat
URL=https://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.19/bin/apache-tomcat-9.0.19.tar.gz
DESCRIPTION="The apache tomcat server."
VERSION=9.0.19

#REQ:java10

cd $SOURCE_DIR

wget -nc https://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.19/bin/apache-tomcat-9.0.19.tar.gz

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

sudo mkdir -pv /opt/tomcat &&
sudo mv * /opt/tomcat/ &&
sudo tee /etc/profile.d/tomcat.sh << "EOF"
export CATALINA_HOME=/opt/tomcat
export PATH=$PATH:$CATALINA_HOME/bin
EOF

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
