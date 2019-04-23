#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gcc
URL=https://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.xz
DESCRIPTION="The GCC package contains the GNU Compiler Collection. This page describes the installation of compilers for the following languages: C, C++, Fortran, Objective C, Objective C++, and Go. One additional language, Ada, is available in the collection. It has specific requirements, so it is described in a separate page (<a class=\xref\ href=\gcc-ada.html\  title=\GCC-Ada-7.3.0\>GCC-Ada-7.3.0</a>). Since C and C++ are installed in LFS, this page is either for upgrading C and C++, or for installing additional compilers."
VERSION=8.3.0

#REC:dejagnu

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.xz

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

case $(uname -m) in
x86_64)
sed -e '/m64=/s/lib64/lib/' \
-i.orig gcc/config/i386/t-linux64
;;
esac

mkdir build &&
cd build &&

../configure \
--prefix=/usr \
--disable-multilib \
--disable-libmpx \
--with-system-zlib \
--enable-languages=c,c++,fortran,go,objc,obj-c++ &&
make
ulimit -s 32768 &&
make -k check
../contrib/test_summary

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

mkdir -pv /usr/share/gdb/auto-load/usr/lib &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib &&

chown -v -R root:root \
/usr/lib/gcc/*linux-gnu/8.3.0/include{,-fixed}
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -v -sf ../usr/bin/cpp /lib &&
ln -v -sf gcc /usr/bin/cc &&
install -v -dm755 /usr/lib/bfd-plugins &&
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.3.0/liblto_plugin.so /usr/lib/bfd-plugins/
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
