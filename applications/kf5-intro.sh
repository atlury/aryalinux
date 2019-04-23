#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=kf5-intro
URL=
DESCRIPTION=""
VERSION=5.53


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

sudo tee -a /etc/profile.d/qt5.sh << "EOF"
# Begin kf5 extension for /etc/profile.d/qt5.sh

pathappend /usr/lib/qt5/plugins    QT_PLUGIN_PATH
pathappend /usr/lib/qt5/qml        QML2_IMPORT_PATH

# End extension for /etc/profile.d/qt5.sh
EOF

sudo tee /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh

export KF5_PREFIX=/usr

# End /etc/profile.d/kf5.sh
EOF

sudo tee -a /etc/sudoers.d/qt << "EOF"
Defaults env_keep += QT_PLUGIN_PATH
Defaults env_keep += QML2_IMPORT_PATH
EOF

sudo tee -a /etc/sudoers.d/kde << "EOF"
Defaults env_keep += KF5_PREFIX
EOF

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
