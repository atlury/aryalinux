#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=python-modules#six
URL=https://pypi.io/packages/source/s/six/six-1.11.0.tar.gz
DESCRIPTION="%DESCRIPTION%"
VERSION=1.11.0

#OPT:python2

cd $SOURCE_DIR

wget -nc https://pypi.io/packages/source/s/six/six-1.11.0.tar.gz

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

python2 setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python2 setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


python3 setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python3 setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
