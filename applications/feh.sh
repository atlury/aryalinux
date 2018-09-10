#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" feh is a fast, lightweight image viewer which uses Imlib2. It is commandline-driven and supports multiple images through slideshows, thumbnail browsing or multiple windows, and montages or index prints (using TrueType fonts to display file info). Advanced features include fast dynamic zooming, progressive loading, loading via HTTP (with reload support for watching webcams), recursive file opening (slideshow of a directory hierarchy), and mouse wheel/keyboard control."
SECTION="xsoft"
VERSION=2.26.3
NAME="feh"

#REQ:libpng
#REQ:imlib2
#REQ:giflib
#REC:curl
#OPT:libexif
#OPT:libjpeg
#OPT:imagemagick
#OPT:perl-modules#perl-test-command


cd $SOURCE_DIR

URL=http://feh.finalrewind.org/feh-2.26.3.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://feh.finalrewind.org/feh-2.26.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/feh/feh-2.26.3.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/feh/feh-2.26.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/feh/feh-2.26.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/feh/feh-2.26.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/feh/feh-2.26.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/feh/feh-2.26.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i "s:doc/feh:&-2.26.3:" config.mk &&
make PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
