#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The unixODBC package is an Open Source ODBC (Open DataBase Connectivity) sub-system and an ODBC SDK for Linux, Mac OSX, and UNIX. ODBC is an open specification for providing application developers with a predictable API with which to access data sources. Data sources include optional SQL Servers and any data source with an ODBC Driver. unixODBC contains the following components used to assist with the manipulation of ODBC data sources: a driver manager, an installer library and command line tool, command line tools to help install a driver and work with SQL, drivers and driver setup libraries."
SECTION="general"
VERSION=2.3.6
NAME="unixodbc"

#OPT:pth


cd $SOURCE_DIR

URL=ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.6.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unixODBC/unixODBC-2.3.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/unixODBC/unixODBC-2.3.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unixODBC/unixODBC-2.3.6.tar.gz

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

./configure --prefix=/usr \
            --sysconfdir=/etc/unixODBC &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
find doc -name "Makefile*" -delete                &&
chmod 644 doc/{lst,ProgrammerManual/Tutorial}/*   &&
install -v -m755 -d /usr/share/doc/unixODBC-2.3.6 &&
cp      -v -R doc/* /usr/share/doc/unixODBC-2.3.6

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
