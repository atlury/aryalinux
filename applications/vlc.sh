#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=vlc
URL=https://download.videolan.org/vlc/3.0.6/vlc-3.0.6.tar.xz
DESCRIPTION="VLC is a media player, streamer, and encoder. It can play from many inputs, such as files, network streams, capture devices, desktops, or DVD, SVCD, VCD, and audio CD. It can use most audio and video codecs (MPEG 1/2/4, H264, VC-1, DivX, WMV, Vorbis, AC3, AAC, etc.), and it can also convert to different formats and/or send streams through the network."
VERSION=3.0.6

#REC:alsa-lib
#REC:ffmpeg
#REC:liba52
#REC:libgcrypt
#REC:libmad
#REC:lua

cd $SOURCE_DIR

wget -nc https://download.videolan.org/vlc/3.0.6/vlc-3.0.6.tar.xz

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

sed -i '/vlc_demux.h/a #define LUA_COMPAT_APIINTCASTS' modules/lua/vlc.h &&
sed -i '/LIBSSH2_VERSION_NUM/s/10801/10900/' modules/access/sftp.c &&

BUILDCC=gcc ./configure --prefix=/usr \
--disable-opencv \
--disable-vpx &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/vlc-3.0.6 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
