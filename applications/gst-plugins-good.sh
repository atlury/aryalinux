#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gst-plugins-good
URL=http://ftp.gnome.org/pub/gnome/sources/gst-plugins-good/0.10/gst-plugins-good-0.10.31.tar.xz
DESCRIPTION=""
VERSION=0.10.31

#REQ:gst-plugins-base
#REC:cairo
#REC:flac
#REC:libjpeg
#REC:libpng
#REC:x7lib
#OPT:GConf
#OPT:libsoup
#OPT:aalib
#OPT:gtk3
#OPT:libdv
#OPT:pulseaudio
#OPT:speex
#OPT:taglib
#OPT:multimedia_atk
#OPT:gtk-doc
#OPT:python2

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gst-plugins-good/0.10/gst-plugins-good-0.10.31.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gst-plugins-good/0.10/gst-plugins-good-0.10.31.tar.xz

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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
