#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=blueman
URL=https://github.com/blueman-project/blueman/releases/download/2.0.5/blueman-2.0.5.tar.xz
DESCRIPTION=""
VERSION=2.0.5

#REQ:obex-data-server
#REQ:python-modules#dbus-python
#REQ:python-modules#pygobject3
#REQ:cython
#REQ:obexfs
#REQ:sbc

cd $SOURCE_DIR

wget -nc $URL

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

sudo usermod -a -G lp `cat /tmp/currentuser`

if [ "`which thunar`" != "" ]
then
	FM="thunar"
elif [ "`which caja`" != "" ]
then
	FM="caja"
elif [ "`which nautilus`" != "" ]
then
	FM="nautilus"
fi
 
cat > obex_filemanager.sh <<EOF
#!/bin/bash
fusermount -u ~/bluetooth
obexfs -b $1 ~/bluetooth
$FM ~/bluetooth
EOF

sudo mv obex_filemanager.sh /usr/bin
sudo chmod a+x /usr/bin/obex_filemanager.sh

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
