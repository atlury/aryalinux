#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=openjpeg2
URL=https://github.com/uclouvain/openjpeg/archive/v2.3.0/openjpeg-2.3.0.tar.gz
DESCRIPTION="OpenJPEG is an open-source implementation of the JPEG-2000 standard. OpenJPEG fully respects the JPEG-2000 specifications and can compress/decompress lossless 16-bit images."
VERSION=2.3.0

#REQ:cmake

cd $SOURCE_DIR

wget -nc https://github.com/uclouvain/openjpeg/archive/v2.3.0/openjpeg-2.3.0.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/openjpeg-2.3.0-only_shared-1.patch

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

patch -Np1 -i ../openjpeg-2.3.0-only_shared-1.patch &&

mkdir -v build &&
cd build &&

cmake -DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr \
-DBUILD_STATIC_LIBS=OFF .. &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

pushd ../doc &&
for man in man/man?/* ; do
install -v -D -m 644 $man /usr/share/$man
done 
popd
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
