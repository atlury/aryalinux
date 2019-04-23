#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=perl-modules#test2-suite
URL=http://search.cpan.org/CPAN/authors/id/E/EX/EXODIST/Test2-Suite-0.000114.tar.gz
DESCRIPTION=""
VERSION=0.000114

#REQ:perl-modules#importer
#REQ:perl-modules#test-simple
#REQ:perl-modules#sub-info
#REQ:perl-modules#term-table
#REQ:perl-modules#module-pluggable
#REQ:perl-modules#scope-guard

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
