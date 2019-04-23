#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=transcode
URL=https://sources.archlinux.org/other/community/transcode/transcode-1.1.7.tar.bz2
DESCRIPTION="Transcode was a fast, versatile and command-line based audio/video everything to everything converter primarily focussed on producing AVI video files with MP3 audio, but also including a program to read all the video and audio streams from a DVD."
VERSION=1.1.7

#REQ:ffmpeg
#REC:alsa-lib
#REC:lame
#REC:libdvdread
#REC:libmpeg2
#REC:x7lib

cd $SOURCE_DIR

wget -nc https://sources.archlinux.org/other/community/transcode/transcode-1.1.7.tar.bz2
wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/transcode-1.1.7.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/transcode-1.1.7-ffmpeg4-1.patch

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

sed -i 's|doc/transcode|&-$(PACKAGE_VERSION)|' \
$(find . -name Makefile.in -exec grep -l 'docsdir =' {} \;) &&

patch -Np1 -i ../transcode-1.1.7-ffmpeg4-1.patch &&
./configure --prefix=/usr \
--enable-alsa \
--enable-libmpeg2 &&
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
