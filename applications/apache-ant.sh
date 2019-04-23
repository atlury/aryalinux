#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=apache-ant
URL=https://archive.apache.org/dist/ant/source/apache-ant-1.10.5-src.tar.xz
DESCRIPTION="The Apache Ant package is a Java-based build tool. In theory, it is like the make command, but without make's wrinkles. Ant is different. Instead of a model that is extended with shell-based commands, Ant is extended using Java classes. Instead of writing shell commands, the configuration files are XML-based, calling out a target tree that executes various tasks. Each task is run by an object that implements a particular task interface."
VERSION=1.10.5

#REQ:java
#REQ:openjdk
#REQ:glib2

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/ant/source/apache-ant-1.10.5-src.tar.xz

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

sed -i 's/--add-modules java.activation/-html4/' build.xml
./bootstrap.sh
bootstrap/bin/ant -f fetch.xml -Ddest=optional
./build.sh -Ddist.dir=$PWD/ant-1.10.5 dist

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cp -rv ant-1.10.5 /opt/ &&
chown -R root:root /opt/ant-1.10.5 &&
ln -sfv ant-1.10.5 /opt/ant
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/profile.d/ant.sh << EOF
# Begin /etc/profile.d/ant.sh

pathappend /opt/ant/bin
export ANT_HOME=/opt/ant

# End /etc/profile.d/ant.sh
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
