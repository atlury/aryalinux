#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=graphviz
URL=http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz
DESCRIPTION="The Graphviz package contains graph visualization software. Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks. Graphviz has several main graph layout programs. It also has web and interactive graphical interfaces, auxiliary tools, libraries, and language bindings."
VERSION=2.40.1


cd $SOURCE_DIR

wget -nc http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/graphviz-2.40.1-qt5-1.patch

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

sed -e '/ruby/s/1\.9/2.6/' -i configure.ac
patch -p1 -i ../graphviz-2.40.1-qt5-1.patch
sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&

autoreconf &&
./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -v -s /usr/share/graphviz/doc \
/usr/share/doc/graphviz-2.40.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
