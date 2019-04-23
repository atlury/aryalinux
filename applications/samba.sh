#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=samba
URL=https://www.samba.org/ftp/samba/stable/samba-4.9.5.tar.gz
DESCRIPTION="The Samba package provides file and print services to SMB/CIFS clients and Windows networking to Linux clients. Samba can also be configured as a Windows Domain Controller replacement, a file/print server acting as a member of a Windows Active Directory domain and a NetBIOS (rfc1001/1002) nameserver (which among other things provides LAN browsing support)."
VERSION=4.9.5

#REQ:jansson
#REQ:libtirpc
#REQ:lmdb
#REQ:python2
#REQ:rpcsvc-proto
#REC:fuse
#REC:gpgme
#REC:libxslt
#REC:perl-parse-yapp
#REC:pycrypto
#REC:openldap

cd $SOURCE_DIR

wget -nc https://www.samba.org/ftp/samba/stable/samba-4.9.5.tar.gz

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

echo "^samba4.rpc.echo.*on.*ncacn_np.*with.*object.*nt4_dc" >> selftest/knownfail
CFLAGS="-I/usr/include/tirpc" \
LDFLAGS="-ltirpc" \
./configure \
--prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--with-piddir=/run/samba \
--with-pammodulesdir=/lib/security \
--enable-fhs \
--without-ad-dc \
--enable-selftest &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

mv -v /usr/lib/libnss_win{s,bind}.so* /lib &&
ln -v -sf ../../lib/libnss_winbind.so.2 /usr/lib/libnss_winbind.so &&
ln -v -sf ../../lib/libnss_wins.so.2 /usr/lib/libnss_wins.so &&

install -v -m644 examples/smb.conf.default /etc/samba &&

mkdir -pv /etc/openldap/schema &&

install -v -m644 examples/LDAP/README \
/etc/openldap/schema/README.LDAP &&

install -v -m644 examples/LDAP/samba* \
/etc/openldap/schema &&

install -v -m755 examples/LDAP/{get*,ol*} \
/etc/openldap/schema
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
