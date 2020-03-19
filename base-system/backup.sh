#!/bin/bash

set -e
set +h

./umountal.sh

. ./build-properties

LABEL=$1
sleep 5

mount $ROOT_PART $LFS

if [ ! -z "$HOME_PART" ]
then

mount $HOME_PART $LFS/home

fi

pushd /

if [ ! -f $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz ]
then

GZIP=-9 tar --exclude="$LFS/sources" \
	--exclude="$LFS/usr/share/doc/*" \
	--exclude="$LFS/tools" \
	--exclude="$LFS/root/.ccache" \
	--exclude="$LFS/root/.cargo" \
	--exclude="$LFS/home/$USERNAME/.ccache" \
	--exclude="$LFS/var/cache/alps/binaries" \
	--exclude="$LFS/var/cache/alps/sources" \
	-czvf $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz $LFS
fi

popd
