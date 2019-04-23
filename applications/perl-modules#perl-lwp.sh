#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=perl-modules#perl-lwp
URL=https://www.cpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.33.tar.gz
DESCRIPTION=""
VERSION=6.33

#REQ:perl-modules#encode-locale
#REQ:perl-modules#perl-uri
#REQ:perl-modules#http-cookies
#REQ:perl-modules#http-negotiate
#REQ:perl-modules#net-http
#REQ:perl-modules#www-robotrules
#REQ:perl-modules#http-daemon
#REQ:perl-modules#file-listing
#REQ:perl-modules#test-requiresinternet
#REQ:perl-modules#perl-test-fatal

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
