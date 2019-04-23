#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=wireless_tools
URL=https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz
DESCRIPTION="The Wireless Extension (WE) is a generic API in the Linux kernel allowing a driver to expose configuration and statistics specific to common Wireless LANs to user space. A single set of tools can support all the variations of Wireless LANs, regardless of their type as long as the driver supports Wireless Extensions. WE parameters may also be changed on the fly without restarting the driver (or Linux)."
VERSION=wireless_tools.29


cd $SOURCE_DIR

wget -nc https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/wireless_tools-29-fix_iwlist_scanning-1.patch

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

patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr INSTALL_MAN=/usr/share/man install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
