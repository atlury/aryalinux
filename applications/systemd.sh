#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" While systemd was installed when building LFS, there are many features provided by the package that were not included in the initial installation because Linux-PAM was not yet installed. The systemd package needs to be rebuilt to provide a working <span class=\"command\"><strong>systemd-logind</strong> service, which provides many additional features for dependent packages."
SECTION="general"
VERSION=239
NAME="systemd"

#REQ:linux-pam
#REC:polkit
#OPT:make-ca
#OPT:curl
#OPT:gnutls
#OPT:iptables
#OPT:libgcrypt
#OPT:libidn2
#OPT:libseccomp
#OPT:libxkbcommon
#OPT:qemu
#OPT:valgrind
#OPT:zsh
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt


cd $SOURCE_DIR

URL=https://github.com/systemd/systemd/archive/v239.tar.gz

if [ ! -z $URL ]
then
wget --content-disposition -nc $URL
TARBALL="systemd-239.tar.gz"
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

sed -i '527,565 d'                  src/basic/missing.h
sed -i '24 d'                       src/core/load-fragment.c
sed -i '53 a#include <sys/mount.h>' src/shared/bus-unit-util.c


sed -i 's/GROUP="render", //' rules/50-udev-default.rules.in


mkdir build &&
cd    build &&
meson --prefix=/usr         \
      --sysconfdir=/etc     \
      --localstatedir=/var  \
      -Dblkid=true          \
      -Dbuildtype=release   \
      -Ddefault-dnssec=no   \
      -Dfirstboot=false     \
      -Dinstall-tests=false \
      -Dldconfig=false      \
      -Drootprefix=         \
      -Drootlibdir=/lib     \
      -Dsplit-usr=true      \
      -Dsysusers=false      \
      -Db_lto=false         \
      ..                    &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -rfv /usr/lib/rpm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition
 
session required pam_loginuid.so
session optional pam_systemd.so
# End Systemd addition
EOF
cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user
account required pam_access.so
account include system-account
session required pam_env.so
session required pam_limits.so
session include system-session
auth required pam_deny.so
password required pam_deny.so
# End /etc/pam.d/systemd-user
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
