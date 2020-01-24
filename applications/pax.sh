#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cpio


cd $SOURCE_DIR

wget -nc http://pub.allbsd.org/MirOS/dist/mir/cpio/paxmirabilis-20161104.cpio.gz


NAME=pax
VERSION=20161104
URL=http://pub.allbsd.org/MirOS/dist/mir/cpio/paxmirabilis-20161104.cpio.gz
SECTION="Miscellaneous"
DESCRIPTION="pax is an archiving utility created by POSIX and defined by the POSIX.1-2001 standard. Rather than sort out the incompatible options that have crept up between tar and cpio, along with their implementations across various versions of UNIX, the IEEE designed a new archive utility. The name “pax” is an acronym for portable archive exchange. Furthermore, “pax” means “peace” in Latin, so its name implies that it shall create peace between the tar and cpio format supporters. The command invocation and command structure is somewhat a unification of both tar and cpio."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


gzip -dck paxmirabilis-20161104.cpio.gz | cpio -mid &&
cd pax &&

sed -i '/stat.h/a #include <sys/sysmacros.h>' cpio.c gen_subs.c tar.c &&

cc -O2 -DLONG_OFF_T -o pax -DPAX_SAFE_PATH=\"/bin\" *.c
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v pax /bin &&
install -v pax.1 /usr/share/man/man1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

