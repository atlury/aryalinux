#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=python-modules#docutils
URL=http://downloads.sourceforge.net/docutils/docutils-0.14.tar.gz
DESCRIPTION="%DESCRIPTION%"
VERSION=0.14

#REC:python2

cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/docutils/docutils-0.14.tar.gz

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

python setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install --optimize=1 &&

for f in /usr/bin/rst*.py; do
  ln -svf $(basename $f) /usr/bin/$(basename $f .py)
done
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
