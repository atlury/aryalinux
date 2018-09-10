#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The JUnit package contains a simple, open source framework to write and run repeatable tests. It is an instance of the xUnit architecture for unit testing frameworks. JUnit features include assertions for testing expected results, test fixtures for sharing common test data, and test runners for running tests."
SECTION="general"
VERSION=4.12
NAME="junit"

#REQ:maven
#REQ:unzip


cd $SOURCE_DIR

URL=https://github.com/junit-team/junit4/archive/r4.12/junit-4.12.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/junit-team/junit4/archive/r4.12/junit-4.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/junit/junit-4.12.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/junit/junit-4.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/junit/junit-4.12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/junit/junit-4.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/junit/junit-4.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/junit/junit-4.12.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -e '/MethodsSorted/i    @Ignore' \
    -i src/test/java/org/junit/runners/model/TestClassTest.java


mvn -DjdkVersion=1.6 install


mvn site



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d             /usr/share/java/junit-4.12 &&
cp -v target/junit-4.12.jar     /usr/share/java/junit-4.12 &&
cp -v lib/hamcrest-core-1.3.jar /usr/share/java/junit-4.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d    /usr/share/doc/junit-4.12 &&
cp -v -R target/site/* /usr/share/doc/junit-4.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
