#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=ekiga
URL=http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz
DESCRIPTION="Ekiga is a VoIP, IP Telephony, and Video Conferencing application that allows you to make audio and video calls to remote users with SIP or H.323 compatible hardware and software. It supports many audio and video codecs and all modern VoIP features for both SIP and H.323. Ekiga is the first Open Source application to support both H.323 and SIP, as well as audio and video."
VERSION=4.0.1

#REQ:boost
#REQ:gnome-icon-theme
#REQ:gtk2
#REQ:opal
#REC:dbus-glib
#REC:GConf
#REC:libnotify
#OPT:avahi
#OPT:evolution-data-server
#OPT:openldap

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-eds     \
            --disable-gdu     \
            --disable-ldap    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
