#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:cmake
#REQ:fltk
#REQ:gnutls
#REQ:libgcrypt
#REQ:libjpeg
#REQ:x7app
#REQ:x7legacy
#REC:imagemagick

cd $SOURCE_DIR

wget -nc https://github.com/TigerVNC/tigervnc/archive/v1.9.0/tigervnc-1.9.0.tar.gz
wget -nc https://www.x.org/pub/individual/xserver/xorg-server-1.20.0.tar.bz2

NAME=tigervnc
VERSION=1.9.0
URL=https://github.com/TigerVNC/tigervnc/archive/v1.9.0/tigervnc-1.9.0.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

# Put code in place
pushd unix/xserver &&
tar -xf $DIR/xorg-server-$XORG_VER.tar.bz2 --strip-components=1 &&
patch -Np1 -i ../xserver120.patch &&
popd &&

# Build viewer
cmake -G "Unix Makefiles" \
-DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
-Wno-dev &&
make &&

# Build server
pushd unix/xserver &&
autoreconf -fiv &&

CFLAGS="$CFLAGS -I/usr/include/drm" \
./configure $XORG_CONFIG \
--disable-xwayland --disable-dri --disable-dmx \
--disable-xorg --disable-xnest --disable-xvfb \
--disable-xwin --disable-xephyr --disable-kdrive \
--disable-devel-docs --disable-config-hal --disable-config-udev \
--disable-unit-tests --disable-selective-werror \
--disable-static --enable-dri3 \
--without-dtrace --enable-dri2 --enable-glx \
--with-pic &&
make &&
popd

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
#Install viewer
make install &&

#Install server
pushd unix/xserver/hw/vnc &&
make install &&
popd &&

[ -e /usr/bin/Xvnc ] || ln -svf $XORG_PREFIX/bin/Xvnc /usr/bin/Xvnc
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /usr/share/applications/vncviewer.desktop << "EOF"
<code class="literal">[Desktop Entry]
Type=Application
Name=TigerVNC Viewer
Comment=VNC client
Exec=/usr/bin/vncviewer
Icon=tigervnc
Terminal=false
StartupNotify=false
Categories=Network;RemoteAccess;</code>
EOF

install -vm644 ../media/icons/tigervnc_24.png /usr/share/pixmaps &&
ln -sfv tigervnc_24.png /usr/share/pixmaps/tigervnc.png
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
