#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=p7zip
URL=https://downloads.sourceforge.net/p7zip/p7zip_16.02_src_all.tar.bz2
DESCRIPTION="p7zip is the Unix command-line port of 7-Zip, a file archiver that archives with high compression ratios. It handles 7z, ZIP, GZIP, BZIP2, XZ, TAR, APM, ARJ, CAB, CHM, CPIO, CramFS, DEB, DMG, FAT, HFS, ISO, LZH, LZMA, LZMA2, MBR, MSI, MSLZ, NSIS, NTFS, RAR RPM, SquashFS, UDF, VHD, WIM, XAR and Z formats."
VERSION=p7zip_16.02_src_all


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/p7zip/p7zip_16.02_src_all.tar.bz2

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

make all3

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make DEST_HOME=/usr \
DEST_MAN=/usr/share/man \
DEST_SHARE_DOC=/usr/share/doc/p7zip-16.02 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
