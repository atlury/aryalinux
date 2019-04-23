#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=qtwebengine
URL=https://download.qt.io/archive/qt/5.12/5.12.2/submodules/qtwebengine-everywhere-src-5.12.2.tar.xz
DESCRIPTION="QtWebEngine integrates chromium\s web capabilities into Qt. It ships with its own copy of ninja which it uses for the build if it cannot find a system copy, and various copies of libraries from ffmpeg, icu, libvpx, and zlib (including libminizip) which have been forked by the chromium developers."
VERSION=5.12.2

#REQ:nss
#REQ:python2
#REQ:qt5
#REC:alsa-lib
#REC:pulseaudio
#REC:ffmpeg
#REC:icu
#REC:libwebp
#REC:libxslt
#REC:opus

cd $SOURCE_DIR

wget -nc https://download.qt.io/archive/qt/5.12/5.12.2/submodules/qtwebengine-everywhere-src-5.12.2.tar.xz

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

find -type f -name "*.pr[io]" |
xargs sed -i -e 's|INCLUDEPATH += |&$$QTWEBENGINE_ROOT/include |'

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
if [ -e ${QT5DIR}/lib/libQtWebEngineCore.so ]; then
mv -v ${QT5DIR}/lib/libQtWebEngineCore.so{,.old}
fi
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir build &&
cd build &&

qmake .. -- -system-ffmpeg -webengine-icu &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
find $QT5DIR/ -name \*.prl \
-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
