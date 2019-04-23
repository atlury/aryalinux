#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gst10-plugins-bad
URL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz
DESCRIPTION="The GStreamer Bad Plug-ins package contains a set of plug-ins that aren't up to par compared to the rest. They might be close to being good quality, but they're missing something - be it a good code review, some documentation, a set of tests, a real live maintainer, or some actual wide use."
VERSION=1.14.4

#REQ:gst10-plugins-base
#REC:libdvdread
#REC:libdvdnav
#REC:llvm
#REC:soundtouch

cd $SOURCE_DIR

wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/gst-plugins-bad-1.14.4-fdkaac_2-1.patch

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

patch -Np1 -i ../gst-plugins-bad-1.14.4-fdkaac_2-1.patch
./configure --prefix=/usr \
--disable-wayland \
--disable-opencv \
--with-package-name="GStreamer Bad Plugins 1.14.4 BLFS" \
--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
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
