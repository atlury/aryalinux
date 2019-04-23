#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=wireshark
URL=https://www.wireshark.org/download/src/all-versions/wireshark-3.0.0.tar.xz
DESCRIPTION="The Wireshark package contains a network protocol analyzer, also known as a sniffer. This is useful for analyzing data captured off the wire from a live network connection, or data read from a capture file."
VERSION=3.0.0

#REQ:glib2
#REQ:libgcrypt
#REQ:qt5
#REC:libpcap

cd $SOURCE_DIR

wget -nc https://www.wireshark.org/download/src/all-versions/wireshark-3.0.0.tar.xz

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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 62 wireshark
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/PROGRAM=wireshark-3.0.0 \
-G Ninja \
.. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

install -v -m755 -d /usr/share/doc/wireshark-3.0.0 &&
install -v -m644 README.linux doc/README.* doc/{*.pod,randpkt.txt} \
/usr/share/doc/wireshark-3.0.0 &&

pushd /usr/share/doc/wireshark-3.0.0 &&
for FILENAME in ../../wireshark/*.html; do
ln -s -v -f $FILENAME .
done &&
popd
unset FILENAME
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 <em class="replaceable"><code><Downloaded_Files></code></em> \
/usr/share/doc/wireshark-3.0.0
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
chown -v root:wireshark /usr/bin/{tshark,dumpcap} &&
chmod -v 6550 /usr/bin/{tshark,dumpcap}
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
usermod -a -G wireshark <username>
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
