#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=asymptote
URL=https://downloads.sourceforge.net/asymptote/asymptote-2.47.src.tgz
DESCRIPTION="Asymptote is a powerful descriptive vector graphics language that provides a natural coordinate-based framework for technical drawing. Labels and equations can be typeset with LaTeX."
VERSION=2.47.src

#REQ:gs
#REQ:texlive
#REC:freeglut
#REC:gc
#REC:libtirpc

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/asymptote/asymptote-2.47.src.tgz

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

cat >> main.cc << EOF

#ifdef USEGC
GC_API void GC_CALL GC_throw_bad_alloc() {
std::bad_alloc();
}
#endif
EOF
export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

./configure --prefix=/opt/texlive/2018 \
--bindir=/opt/texlive/2018/bin/$TEXARCH \
--datarootdir=/opt/texlive/2018/texmf-dist \
--infodir=/opt/texlive/2018/texmf-dist/doc/info \
--libdir=/opt/texlive/2018/texmf-dist \
--mandir=/opt/texlive/2018/texmf-dist/doc/man \
--enable-gc=system \
--with-latex=/opt/texlive/2018/texmf-dist/tex/latex \
--with-context=/opt/texlive/2018/texmf-dist/tex/context/third &&

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
