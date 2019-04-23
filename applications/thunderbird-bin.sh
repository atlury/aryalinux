#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=thunderbird-bin
URL=
DESCRIPTION="Thunderbird is a mail client from mozilla. This package simply downloads and installs the most current version of Thunderbird (which is not very current)"
VERSION=latest

#REQ:curl
#REQ:alsa-lib
#REQ:gtk2
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:sqlite
#OPT:curl
#OPT:cyrus-sasl
#OPT:dbus-glib
#OPT:doxygen
#OPT:gst-plugins-base
#OPT:gst-plugins-good
#OPT:gst-ffmpeg
#OPT:gst10-plugins-base
#OPT:gst10-plugins-good
#OPT:gst10-libav
#OPT:libnotify
#OPT:openjdk
#OPT:pulseaudio
#OPT:startup-notification
#OPT:wget
#OPT:wireless_tools

cd $SOURCE_DIR


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
