#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The FOP (Formatting Objects Processor) package contains a print formatter driven by XSL formatting objects (XSL-FO). It is a Java application that reads a formatting object tree and renders the resulting pages to a specified output. Output formats currently supported include PDF, PCL, PostScript, SVG, XML (area tree representation), print, AWT, MIF and ASCII text. The primary output target is PDF."
SECTION="pst"
VERSION=2.2
NAME="fop"

#REQ:apache-ant
#OPT:junit
#OPT:maven
#OPT:xorg-server


cd $SOURCE_DIR

URL=https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.2-src.tar.gz

if [ ! -z $URL ]
then
wget -nc https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.2-src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fop/fop-2.2-src.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fop/fop-2.2-src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fop/fop-2.2-src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fop/fop-2.2-src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fop/fop-2.2-src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fop/fop-2.2-src.tar.gz
wget -nc https://downloads.sourceforge.net/offo/2.2/offo-hyphenation.zip

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

unzip ../offo-hyphenation.zip &&
cp offo-hyphenation/hyph/* fop/hyph &&
rm -rf offo-hyphenation


sed -i '\@</javad@i\
<arg value="-Xdoclint:none"/>\
<arg value="--allow-script-in-comments"/>\
<arg value="--ignore-source-errors"/>' \
    fop/build.xml


sed -e '/hyph\.stack/s/512k/1M/' \
    -i fop/build.xml


cd fop                    &&
export LC_ALL=en_US.UTF-8 &&
ant all javadocs          &&
mv build/javadocs .


sed -e '/haltonfailure/s/yes/off/' \
    -i build.xml



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 -o root -g root          /opt/fop-2.2 &&
cp -v  ../{KEYS,LICENSE,NOTICE,README}       /opt/fop-2.2 &&
cp -vR build conf examples fop* javadocs lib /opt/fop-2.2 &&
chmod a+x /opt/fop-2.2/fop                                &&
ln -v -sfn fop-2.2 /opt/fop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.foprc << "EOF"
FOP_OPTS="-Xmx<em class="replaceable"><code><RAM_Installed></em>m"
FOP_HOME="/opt/fop"
EOF




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
