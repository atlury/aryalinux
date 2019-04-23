#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=mplayer
URL=http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz
DESCRIPTION="MPlayer is a powerful audio/video player controlled via the command line or a graphical interface that is able to play almost every popular audio and video file format. With supported video hardware and additional drivers, MPlayer can play video files without an X Window System installed."
VERSION=1.3.0

#REQ:yasm
#REC:gtk2
#REC:libvdpau-va-gl

cd $SOURCE_DIR

wget -nc http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz
wget -nc ftp://ftp.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/MPlayer-1.3.0-x264_fix-1.patch
wget -nc https://www.mplayerhq.hu/MPlayer/skins/Clearlooks-2.0.tar.bz2
wget -nc ftp://ftp.mplayerhq.hu/MPlayer/skins/Clearlooks-2.0.tar.bz2

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

patch -Np0 -i ../MPlayer-1.3.0-x264_fix-1.patch &&

./configure --prefix=/usr \
--confdir=/etc/mplayer \
--enable-dynamic-plugins \
--enable-menu \
--enable-gui &&
make
make doc

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
ln -svf ../icons/hicolor/48x48/apps/mplayer.png \
/usr/share/pixmaps/mplayer.png
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/mplayer-1.3.0 &&
install -v -m644 DOCS/HTML/en/* \
/usr/share/doc/mplayer-1.3.0
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 etc/codecs.conf /etc/mplayer
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 etc/*.conf /etc/mplayer
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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xvf ../Clearlooks-2.0.tar.bz2 \
-C /usr/share/mplayer/skins &&
ln -sfvn Clearlooks /usr/share/mplayer/skins/default
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
