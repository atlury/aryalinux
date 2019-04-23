#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=mysql
URL=https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.12.tar.gz
DESCRIPTION=""
VERSION=8.0.12

#REQ:cmake
#REQ:openssl10
#REQ:libaio
#REC:libevent
#OPT:boost
#OPT:libxml2
#OPT:linux-pam
#OPT:pcre
#OPT:ruby
#OPT:unixodbc
#OPT:valgrind

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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
