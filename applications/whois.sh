#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=whois
URL=https://github.com/rfc1036/whois/archive/v5.4.2/whois-5.4.2.tar.gz
DESCRIPTION="Whois is a client-side application which queries the whois directory service for information pertaining to a particular domain name. This package will install two programs by default: <span class=\command\><strong>whois</strong> and <span class=\command\><strong>mkpasswd</strong>. The <span class=\command\><strong>mkpasswd</strong> command is also installed by the <a class=\xref\ href=\../general/expect.html\  title=\Expect-5.45.4\>Expect-5.45.4</a> package."
VERSION=5.4.2


cd $SOURCE_DIR

wget -nc https://github.com/rfc1036/whois/archive/v5.4.2/whois-5.4.2.tar.gz

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

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make prefix=/usr install-whois
make prefix=/usr install-mkpasswd
make prefix=/usr install-pos
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
