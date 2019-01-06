#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gc
#REQ:libunistring
#OPT:emacs
#OPT:gdb

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.xz

NAME=guile
VERSION=2.2.4
URL=https://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.xz

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

./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/guile-2.2.4 &&
make &&
make html &&

makeinfo --plaintext -o doc/r5rs/r5rs.txt doc/r5rs/r5rs.texi &&
makeinfo --plaintext -o doc/ref/guile.txt doc/ref/guile.texi

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
make install-html &&

mv /usr/lib/libguile-*-gdb.scm /usr/share/gdb/auto-load/usr/lib &&
mv /usr/share/doc/guile-2.2.4/{guile.html,ref} &&
mv /usr/share/doc/guile-2.2.4/r5rs{.html,} &&

find examples -name "Makefile*" -delete &&
cp -vR examples /usr/share/doc/guile-2.2.4 &&

for DIRNAME in r5rs ref; do
install -v -m644 doc/${DIRNAME}/*.txt \
/usr/share/doc/guile-2.2.4/${DIRNAME}
done &&
unset DIRNAME
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
