#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=perl-specio
URL=https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.43.tar.gz
DESCRIPTION=""
VERSION=0.43

#REQ:perl-devel-stacktrace
#REQ:perl-eval-closure
#REQ:perl-module-runtime
#REQ:perl-role-tiny
#REQ:perl-sub-quote
#REQ:perl-try-tiny
#REC:perl-mro-compat
#REC:perl-test-fatal
#REC:perl-test-needs

cd $SOURCE_DIR

wget -nc https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.43.tar.gz

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

perl Makefile.PL &&
make &&


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
