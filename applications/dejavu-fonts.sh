#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=dejavu-fonts
URL=https://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-2.37.tar.bz2
DESCRIPTION="These fonts are an extension of, and replacement for, the Bitstream Vera fonts and provide Latin-based scripts with accents and punctuation such as smart-quotes and variant spacing characters, as well as Cyrillic, Greek, Arabic, Hebrew, Armenian, Georgian and some other glyphs. In the absence of the Bitstream Vera fonts (which had much less coverage), these are the default fallback fonts."
VERSION=2.37

#REQ:fontforge
#REQ:perl-font-ttf
#REQ:perl-io-string

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-2.37.tar.bz2

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

make full-ttf
sudo mkdir -pv /usr/share/fonts/TTF/DejaVu
sudo cp -f build/*.ttf /usr/share/fonts/TTF/DejaVu

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
