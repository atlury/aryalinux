#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=yasm
URL=http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
DESCRIPTION="Yasm is a complete rewrite of the <a class=\xref\ href=\nasm.html\ title=\NASM-2.13.03\>NASM-2.13.03</a> assembler. It supports the x86 and AMD64 instruction sets, accepts NASM and GAS assembler syntaxes and outputs binary, ELF32 and ELF64 object formats."
VERSION=1.3.0


cd $SOURCE_DIR

wget -nc http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz

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

sed -i 's#) ytasm.*#)#' Makefile.in &&

./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
