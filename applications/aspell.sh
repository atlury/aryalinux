#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=aspell
URL=https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz
DESCRIPTION="The Aspell package contains an interactive spell checking program and the Aspell libraries. Aspell can either be used as a library or as an independent spell checker."
VERSION=0.60.6.1

#REQ:which

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz
wget -nc https://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2018.04.16-0.tar.bz2

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

sed -i '/ top.do_check ==/s/top.do_check/*&/' modules/filter/tex.cpp &&
sed -i '/word ==/s/word/*&/' prog/check_funs.cpp
./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
ln -svfn aspell-0.60 /usr/lib/aspell &&

install -v -m755 -d /usr/share/doc/aspell-0.60.6.1/aspell{,-dev}.html &&

install -v -m644 manual/aspell.html/* \
/usr/share/doc/aspell-0.60.6.1/aspell.html &&

install -v -m644 manual/aspell-dev.html/* \
/usr/share/doc/aspell-0.60.6.1/aspell-dev.html
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m 755 scripts/ispell /usr/bin/
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m 755 scripts/spell /usr/bin/
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cd $SOURCE_DIR
tar -xf aspell6-en-2018.04.16-0.tar.bz2
cd aspell6-en-2018.04.16-0
./configure &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cd ..
rm -r aspell6-en-2018.04.16-0

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
