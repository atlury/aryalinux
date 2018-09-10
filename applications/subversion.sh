#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" Subversion is a version control system that is designed to be a compelling replacement for CVS in the open source community. It extends and enhances CVS' feature set, while maintaining a similar interface for those already familiar with CVS. These instructions install the client and server software used to manipulate a Subversion repository. Creation of a repository is covered at <a class=\"xref\"  href=\"svnserver.html\" title=\"Running a Subversion Server\">Running a Subversion Server</a>."
SECTION="general"
VERSION=1.10.0
NAME="subversion"

#REQ:apr-util
#REQ:sqlite
#REC:serf
#OPT:apache
#OPT:cyrus-sasl
#OPT:dbus
#OPT:libsecret
#OPT:python2
#OPT:ruby
#OPT:swig
#OPT:openjdk
#OPT:junit


cd $SOURCE_DIR

URL=https://archive.apache.org/dist/subversion/subversion-1.10.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://archive.apache.org/dist/subversion/subversion-1.10.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/subversion/subversion-1.10.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/subversion/subversion-1.10.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/subversion/subversion-1.10.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/subversion/subversion-1.10.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/subversion/subversion-1.10.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/subversion/subversion-1.10.0.tar.bz2

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

./configure --prefix=/usr             \
            --disable-static          \
            --with-apache-libexecdir  \
            --with-lz4=internal       \
            --with-utf8proc=internal &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/subversion-1.10.0 &&
cp      -v -R       doc/* \
                    /usr/share/doc/subversion-1.10.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
