#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://github.com/djlucas/LSB-Tools/releases/download/v0.5/LSB-Tools-0.5.tar.gz


NAME=lsb-tools
VERSION=0.5
URL=https://github.com/djlucas/LSB-Tools/releases/download/v0.5/LSB-Tools-0.5.tar.gz
SECTION="System Utilities"
DESCRIPTION="The LSB-Tools package includes tools for Linux Standards Base (LSB) conformance."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


python3 setup.py build
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
python3 setup.py install --optimize=1       &&
ln -sv /usr/lib/lsb/install_initd /usr/sbin &&
ln -sv /usr/lib/lsb/remove_initd  /usr/sbin
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

