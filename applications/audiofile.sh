#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=audiofile
URL=http://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz
DESCRIPTION="The AudioFile package contains the audio file libraries and two sound file support programs useful to support basic sound file formats."
VERSION=0.3.6

#REQ:alsa-lib
#REC:flac

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz

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

CXXFLAGS=-std=c++98 \
./configure --prefix=/usr --disable-static &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
