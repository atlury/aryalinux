#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Systemd is the init system for linux."
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

URL=https://github.com/systemd/systemd/archive/v239/systemd-239.tar.gz

if [ ! -z $URL ]
then
wget -nc $URL
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/systemd-239-glibc_statx_fix-1.patch
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

patch -Np1 ../systemd-239-glibc_statx_fix-1.patch
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
sudo ninja install
sudo rm -rfv /usr/lib/rpm

sudo tee -a /etc/pam.d/system-session << "EOF"
# Begin Systemd addition
 
session required pam_loginuid.so
session optional pam_systemd.so
# End Systemd addition
EOF

sudo tee /etc/pam.d/systemd-user << "EOF"
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


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
