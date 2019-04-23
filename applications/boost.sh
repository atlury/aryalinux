#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=boost
URL=https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2
DESCRIPTION="Boost provides a set of free peer-reviewed portable C++ source libraries. It includes libraries for linear algebra, pseudorandom number generation, multithreading, image processing, regular expressions and unit testing."
VERSION=boost_1_69_0

#REC:which

cd $SOURCE_DIR

wget -nc https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2

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

./bootstrap.sh --prefix=/usr &&
./b2 stage threading=multi link=shared

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
./b2 install threading=multi link=shared &&
ln -svf detail/sha1.hpp /usr/include/boost/uuid/sha1.hpp
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
