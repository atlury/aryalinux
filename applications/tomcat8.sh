#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="The apache tomcat server."
NAME="apache-tomcat"
VERSION="8.0.36"

cd $SOURCE_DIR

URL=https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

sudo tar -xf $TARBALL -C /opt/
sudo ln -s /opt/$DIRECTORY /opt/tomcat
sudo tee /etc/profile.d/tomcat.sh<<"EOF"
export CATALINA_HOME=/opt/tomcat
pathappend $CATALINA_HOME/bin
EOF

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
