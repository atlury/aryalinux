#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=docbook-utils
URL=https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz
DESCRIPTION="The DocBook-utils package is a collection of utility scripts used to convert and analyze SGML documents in general, and DocBook files in particular. The scripts are used to convert from DocBook or other SGML formats into classical file formats like HTML, man, info, RTF and many more. There's also a utility to compare two SGML files and only display the differences in markup. This is useful for comparing documents prepared for different languages."
VERSION=0.6.14

#REQ:openjade
#REQ:docbook-dsssl
#REQ:sgml-dtd-3

cd $SOURCE_DIR

wget -nc https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz
wget -nc ftp://sourceware.org/pub/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/docbook-utils-0.6.14-grep_fix-1.patch

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

patch -Np1 -i ../docbook-utils-0.6.14-grep_fix-1.patch &&
sed -i 's:/html::' doc/HTML/Makefile.in &&

./configure --prefix=/usr --mandir=/usr/share/man &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
for doctype in html ps dvi man pdf rtf tex texi txt
do
ln -svf docbook2$doctype /usr/bin/db2$doctype
done
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
