#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" VLC is a media player, streamer, and encoder. It can play from many inputs, such as files, network streams, capture devices, desktops, or DVD, SVCD, VCD, and audio CD. It can use most audio and video codecs (MPEG 1/2/4, H264, VC-1, DivX, WMV, Vorbis, AC3, AAC, etc.), and it can also convert to different formats and/or send streams through the network."
SECTION="multimedia"
VERSION=3.0.3
NAME="vlc"

#REC:alsa-lib
#REC:ffmpeg
#REC:liba52
#REC:libgcrypt
#REC:libmad
#REC:lua
#REC:xorg-server
#REC:dbus
#REC:libcddb
#REC:libdv
#REC:libdvdcss
#REC:libdvdread
#REC:libdvdnav
#REC:opencv
#OPT:samba
#REC:v4l-utils
#REC:libcdio
#REC:libogg
#REC:faad2
#REC:flac
#REC:libass
#REC:libmpeg2
#REC:libpng
#REC:libtheora
#REC:x7driver
#REC:libvorbis
#OPT:opus
#OPT:speex
#REC:x264
#REC:x265
#REC:aalib
#REC:fontconfig
#REC:freetype2
#REC:fribidi
#REC:librsvg
#REC:sdl
#REC:pulseaudio
#REC:libsamplerate
#OPT:qt5
#REC:avahi
#REC:gnutls
#REC:libnotify
#OPT:libxml2
#OPT:taglib
#OPT:xdg-utils
#REQ:libaacs


cd $SOURCE_DIR

URL=https://download.videolan.org/vlc/3.0.3/vlc-3.0.3.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL
wget -nc https://vlc-bluray.whoknowsmy.name/files/KEYDB.cfg

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

export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
BUILDCC=gcc ./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"
make docdir=/usr/share/doc/vlc-3.0.3 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

sudo gtk-update-icon-cache &&
sudo update-desktop-database
sudo mkdir -pv /etc/skel/.config/aacs/
sudo cp $SOURCE_DIR/KEYDB.cfg /etc/skel/.config/aacs/


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
