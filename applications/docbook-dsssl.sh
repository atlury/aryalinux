#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:sgml-common
#REQ:sgml-dtd-3
#REQ:sgml-dtd
#REQ:opensp
#REQ:openjade

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2
wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/docbook-dsssl-1.79.tar.bz2
wget -nc https://downloads.sourceforge.net/docbook/docbook-dsssl-doc-1.79.tar.bz2

NAME=docbook-dsssl
VERSION=1.79.
URL=https://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

tar -xf ../docbook-dsssl-doc-1.79.tar.bz2 --strip-components=1

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 bin/collateindex.pl /usr/bin &&
install -v -m644 bin/collateindex.pl.1 /usr/share/man/man1 &&
install -v -d -m755 /usr/share/sgml/docbook/dsssl-stylesheets-1.79 &&
cp -v -R * /usr/share/sgml/docbook/dsssl-stylesheets-1.79 &&

install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
/usr/share/sgml/docbook/dsssl-stylesheets-1.79/catalog &&

install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
/usr/share/sgml/docbook/dsssl-stylesheets-1.79/common/catalog &&

install-catalog --add /etc/sgml/sgml-docbook.cat \
/etc/sgml/dsssl-docbook-stylesheets.cat
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cd /usr/share/sgml/docbook/dsssl-stylesheets-1.79/doc/testdata
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
openjade -t rtf -d jtest.dsl jtest.sgm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
onsgmls -sv test.sgm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
openjade -t rtf \
-d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/print/docbook.dsl \
test.sgm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
openjade -t sgml \
-d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/html/docbook.dsl \
test.sgm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
rm jtest.rtf test.rtf c1.htm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
