#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=llvm
URL=http://llvm.org/releases/8.0.0/llvm-8.0.0.src.tar.xz
DESCRIPTION="The LLVM package contains a collection of modular and reusable compiler and toolchain technologies. The Low Level Virtual Machine (LLVM) Core libraries provide a modern source and target-independent optimizer, along with code generation support for many popular CPUs (as well as some less common ones!). These libraries are built around a well specified code representation known as the LLVM intermediate representation (\LLVM IR\)."
VERSION=8.0.0.src

#REQ:cmake

cd $SOURCE_DIR

wget -nc http://llvm.org/releases/8.0.0/llvm-8.0.0.src.tar.xz
wget -nc http://llvm.org/releases/8.0.0/cfe-8.0.0.src.tar.xz
wget -nc http://llvm.org/releases/8.0.0/compiler-rt-8.0.0.src.tar.xz

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

tar -xf ../cfe-8.0.0.src.tar.xz -C tools &&
tar -xf ../compiler-rt-8.0.0.src.tar.xz -C projects &&

mv tools/cfe-8.0.0.src tools/clang &&
mv projects/compiler-rt-8.0.0.src projects/compiler-rt
mkdir -v build &&
cd build &&

CC=gcc CXX=g++ \
cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DLLVM_ENABLE_FFI=ON \
-DCMAKE_BUILD_TYPE=Release \
-DLLVM_BUILD_LLVM_DYLIB=ON \
-DLLVM_LINK_LLVM_DYLIB=ON \
-DLLVM_ENABLE_RTTI=ON \
-DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
-DLLVM_BUILD_TESTS=ON \
-Wno-dev -G Ninja .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
