#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=noto-fonts
URL=
DESCRIPTION="The noto-fonts package ('No Tofu' i.e. avoiding boxes with dots [ hex digits ] when a glyph cannot be found) is a set of fonts which aim to cover <span class=\emphasis\><em>every glyph in unicode, no matter how obscure</em>. These fonts, or at least the Sans Serif fonts, are used by KF5 (initially only for gtk applications)."
VERSION=1.4


cd $SOURCE_DIR

wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto{Sans,Serif,SansDisplay,SerifDisplay,Mono}-hinted.zip
wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto{ColorEmoji,Emoji}-unhinted.zip

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

sudo mkdir -pv /usr/share/fonts/truetype/noto-fonts
mkdir -pv noto-fonts && cd noto-fonts
wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto{Sans,Serif,SansDisplay,SerifDisplay,Mono}-hinted.zip
wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto{ColorEmoji,Emoji}-unhinted.zip
find . -name "*zip" -exec sudo unzip -o {} -d /usr/share/fonts/truetype/noto-fonts \;

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
