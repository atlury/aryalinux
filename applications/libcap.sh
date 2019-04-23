#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libcap
URL=https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.26.tar.xz
DESCRIPTION="The libcap package was installed in LFS, but if Linux-PAM support is desired, the PAM module must be built (after installation of Linux-PAM)."
VERSION=2.26

#REQ:linux-pam

cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.26.tar.xz

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

make -C pam_cap

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 pam_cap/pam_cap.so /lib/security &&
install -v -m644 pam_cap/capability.conf /etc/security
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
