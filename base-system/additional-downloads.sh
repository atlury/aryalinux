7#!/bin/bash

set -e
set +h

VERSION=1.1

CURRENT_DIR=$(pwd)
pushd ~/sources

wget -nc https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.xz
wget -nc http://ftp.gnu.org/gnu/which/which-2.21.tar.gz
wget -nc http://http.debian.net/debian/pool/main/o/os-prober/os-prober_1.76.tar.xz
wget -nc https://github.com/rhboot/efivar/releases/download/36/efivar-36.tar.bz2
wget -nc https://github.com/rhboot/efibootmgr/releases/download/16/efibootmgr-16.tar.bz2
wget -nc https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2
wget -nc https://ftp.gnu.org/gnu/unifont/unifont-7.0.05/unifont-7.0.05.pcf.gz
wget -nc https://mirrors.edge.kernel.org/pub/software/utils/pciutils/pciutils-3.6.2.tar.xz
wget -nc https://launchpad.net/popt/head/1.16/+download/popt-1.16.tar.gz
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/linux-firmware.tar.xz
wget -nc https://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2
wget -nc https://ftp.osuosl.org/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz
wget -nc https://busybox.net/downloads/busybox-1.29.3.tar.bz2
wget -nc https://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz
wget -nc https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.13.tar.gz
wget -nc https://github.com/p11-glue/p11-kit/releases/download/0.23.14/p11-kit-0.23.14.tar.gz
wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.3.tar.xz
wget -nc https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz
wget -nc http://ftp.ussg.iu.edu/security/sudo/sudo-1.8.25p1.tar.gz
wget -nc https://github.com/djlucas/make-ca/archive/v0.7/make-ca-0.7.tar.gz
wget -nc http://www.cacert.org/certs/root.crt
wget -nc http://www.cacert.org/certs/class3.crt
wget -nc https://hg.mozilla.org/projects/nss/raw-file/tip/lib/ckfw/builtins/certdata.txt
wget -nc https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
wget -nc http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.10.tar.gz

wget -nc https://github.com/dracutdevs/dracut/archive/master.zip
unzip master.zip
tar -cJvf dracut-master.tar.xz dracut-master
rm -r dracut-master
rm -r master.zip

wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/399ee7eb552ec30015e1a7e07e357f5815d25951/grub-2.02-gcc.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/f17f18defa4d88c427e54457e02c6ca94d76b673/efibootmgr-16-efidir.patch
wget -nc https://sourceware.org/ftp/lvm2/releases/LVM2.2.02.171.tgz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/dd59ff658aa9ec0a24de11fa6d5f0acda9bb7628/aufs-4.18.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/dd59ff658aa9ec0a24de11fa6d5f0acda9bb7628/aufs4-base.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/dd59ff658aa9ec0a24de11fa6d5f0acda9bb7628/aufs4-kbuild.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/dd59ff658aa9ec0a24de11fa6d5f0acda9bb7628/aufs4-mmap.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/dd59ff658aa9ec0a24de11fa6d5f0acda9bb7628/aufs4-standalone.patch
wget -nc https://raw.githubusercontent.com/openembedded/openembedded-core/master/meta/recipes-core/systemd/systemd/0001-binfmt-Don-t-install-dependency-links-at-install-tim.patch
wget -nc https://sourceware.org/ftp/elfutils/0.170/elfutils-0.170.tar.bz2

pushd $CURRENT_DIR/../applications
git checkout $VERSION
git pull
tar -czf alps-scripts-$VERSION.tar.gz *.sh
popd

mv -f $CURRENT_DIR/../applications/alps-scripts-$VERSION.tar.gz .

wget -nc https://sourceforge.net/projects/cdrtools/files/cdrtools-3.01.tar.bz2
wget -nc https://launchpad.net/ubuntu/+archive/primary/+files/cdrkit_1.1.11.orig.tar.gz
wget -nc https://cmake.org/files/v3.9/cmake-3.9.1.tar.gz
wget -nc https://sourceforge.net/projects/squashfs/files/squashfs/squashfs4.3/squashfs4.3.tar.gz
wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz

set +e

wget -c https://bitbucket.org/chandrakantsingh/alps/get/master.tar.bz2 -O alps-master.tar.bz2

set -e

popd
