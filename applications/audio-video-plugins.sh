#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=audio-video-plugins
URL=
DESCRIPTION="Meta package to install audio-video codecs for multimedia applications."
VERSION=N.A.

#REQ:fltk
#REQ:alsa-plugins
#REQ:alsa-utils
#REQ:alsa-tools
#REQ:alsa-firmware
#REQ:libtheora
#REQ:flac
#REQ:faac
#REQ:xvid
#REQ:lame
#REQ:libdvdread
#REQ:libdvdnav
#REQ:gst10-plugins-base
#REQ:gst10-plugins-good
#REQ:soundtouch
#REQ:gst10-plugins-bad
#REQ:x264
#REQ:x265
#REQ:gst10-plugins-ugly
#REQ:libdvdcss
#REQ:libcdio
#REQ:libdiscid
#REQ:libmad
#REQ:libmpeg2
#REQ:libquicktime
#REQ:json-c
#REQ:libsndfile
#REQ:libcap
#REQ:speex
#REQ:pulseaudio
#REQ:glu
#REQ:v4l-utils
#REQ:libmusicbrainz
#REQ:neon
#REQ:libmusicbrainz5
#REQ:faad2
#REQ:fdk-aac
#REQ:gst10-libav
#REQ:liba52
#REQ:libao
#REQ:fribidi
#REQ:libass
#REQ:libdv
#REQ:libsamplerate
#REQ:opus
#REQ:sdl
#REQ:taglib
#REQ:ffmpeg

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
