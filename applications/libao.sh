#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libao
URL=https://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz
DESCRIPTION="The libao package contains a cross-platform audio library. This is useful to output audio on a wide variety of platforms. It currently supports WAV files, OSS (Open Sound System), ESD (Enlighten Sound Daemon), ALSA (Advanced Linux Sound Architecture), NAS (Network Audio system), aRTS (analog Real-Time Synthesizer), and PulseAudio (next generation GNOME sound architecture)."
VERSION=1.2.0


cd $SOURCE_DIR

wget -nc https://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz

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

./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m644 README /usr/share/doc/libao-1.2.0
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
