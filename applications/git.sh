#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=git
URL=https://www.kernel.org/pub/software/scm/git/git-2.21.0.tar.xz
DESCRIPTION="Git is a free and open source, distributed version control system designed to handle everything from small to very large projects with speed and efficiency. Every Git clone is a full-fledged repository with complete history and full revision tracking capabilities, not dependent on network access or a central server. Branching and merging are fast and easy to do. Git is used for version control of files, much like tools such as <a class=\xref\ href=\mercurial.html\ title=\Mercurial-4.6\>Mercurial-4.6</a>, Bazaar, <a class=\xref\ href=\subversion.html\  title=\Subversion-1.10.0\>Subversion-1.10.0</a>, <a class=\ulink\  href=\http://www.nongnu.org/cvs/\>CVS</a>, Perforce, and Team Foundation Server."
VERSION=2.21.0

#REC:curl

cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/software/scm/git/git-2.21.0.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-manpages-2.21.0.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.21.0.tar.xz

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

./configure --prefix=/usr --with-gitconfig=/etc/gitconfig &&
make

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
