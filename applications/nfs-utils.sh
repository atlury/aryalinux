#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libtirpc
#REQ:rpcsvc-proto
#REQ:rpcbind


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/nfs/nfs-utils-2.4.1.tar.xz


NAME=nfs-utils
VERSION=2.4.1
URL=https://downloads.sourceforge.net/nfs/nfs-utils-2.4.1.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


groupadd -g 99 nogroup &&
useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup \
    -s /bin/false -u 99 nobody
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --sbindir=/sbin        \
            --disable-nfsv4        \
            --disable-gss &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install                      &&
mv -v /sbin/start-statd /usr/sbin &&
chmod u+w,go+r /sbin/mount.nfs    &&
chown nobody.nogroup /var/lib/nfs
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat >> /etc/exports << EOF
/home 192.168.0.0/24(rw,subtree_check,anonuid=99,anongid=99)
EOF
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20191026.tar.xz
tar xf blfs-systemd-units-20191026.tar.xz
cd blfs-systemd-units-20191026
sudo make install-nfsv4-server
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20191026.tar.xz
tar xf blfs-systemd-units-20191026.tar.xz
cd blfs-systemd-units-20191026
sudo make install-nfs-server
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

<server-name>:/home  /home nfs   rw,_netdev 0 0
<server-name>:/usr   /usr  nfs   ro,_netdev 0 0
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20191026.tar.xz
tar xf blfs-systemd-units-20191026.tar.xz
cd blfs-systemd-units-20191026
sudo make install-nfs-client
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

