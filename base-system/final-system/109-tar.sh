#!/bin/bash

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="109-tar.sh"
TARBALL="tar-1.30.tar.xz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

FORCE_UNSAFE_CONFIGURE=1  \
CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" ./configure --prefix=/usr \
            --bindir=/bin
make
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.30


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi