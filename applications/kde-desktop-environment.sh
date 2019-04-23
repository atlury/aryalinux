#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=kde-desktop-environment
URL=
DESCRIPTION="The KDE 5 Plasma Desktop environment"
VERSION=5.53

#REQ:extra-cmake-modules
#REQ:phonon
#REQ:phonon-backend-gstreamer
#REQ:polkit-qt
#REQ:libdbusmenu-qt
#REQ:krameworks5
#REQ:fftw
#REQ:plasma-all
#REQ:ark5
#REQ:kdenlive
#REQ:kmix5
#REQ:khelpcenter
#REQ:konsole5
#REQ:lightdm

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

sudo ln -svf /usr/lib /usr/lib64

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
