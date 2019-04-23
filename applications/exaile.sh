#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=exaile
URL=https://github.com/exaile/exaile/releases/download/4.0.0-beta1/exaile-4.0.0beta1.tar.gz
DESCRIPTION=""
VERSION=4.0.0beta1

#REQ:gst10-plugins-base
#REQ:gst10-plugins-good
#REQ:gst10-plugins-bad
#REQ:gst10-plugins-ugly
#REQ:gst10-libav
#REQ:mutagen
#REQ:python-modules#dbus-python

cd $SOURCE_DIR

wget -nc $URL

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
