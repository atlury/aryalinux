#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://download.docker.com/linux/static/stable/x86_64/docker-19.03.5.tgz


NAME=docker
VERSION=19.03.5
URL=https://download.docker.com/linux/static/stable/x86_64/docker-19.03.5.tgz

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

sudo mv * /usr/bin/

sudo tee /etc/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Daemon
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/bin/dockerd

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable docker
sudo systemctl start docker

sudo groupadd docker
echo "Please add usernames to docker group"


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
