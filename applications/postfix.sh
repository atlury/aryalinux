#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=postfix
URL=ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.4.5.tar.gz
DESCRIPTION="The Postfix package contains a Mail Transport Agent (MTA). This is useful for sending email to other users of your host machine. It can also be configured to be a central mail server for your domain, a mail relay agent or simply a mail delivery agent to your local Internet Service Provider."
VERSION=3.4.5

#REC:db
#REC:cyrus-sasl
#REC:libnsl

cd $SOURCE_DIR

wget -nc ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.4.5.tar.gz
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2

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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 32 postfix &&
groupadd -g 33 postdrop &&
useradd -c "Postfix Daemon User" -d /var/spool/postfix -g postfix \
-s /bin/false -u 32 postfix &&
chown -v postfix:postfix /var/mail
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sed -i 's/.\x08//g' README_FILES/*
sed -i -e 's/\$RELEASE_MAJOR/3/' \
-e '/Linux..3/s/34/345/' makedefs
make CCARGS="-DUSE_TLS -I/usr/include/openssl/ \
-DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl" \
AUXLIBS="-lssl -lcrypto -lsasl2" \
makefiles &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sh postfix-install -non-interactive \
daemon_directory=/usr/lib/postfix \
manpage_directory=/usr/share/man \
html_directory=/usr/share/doc/postfix-3.4.5/html \
readme_directory=/usr/share/doc/postfix-3.4.5/readme
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/aliases << "EOF"
# Begin /etc/aliases

MAILER-DAEMON: postmaster
postmaster: root

<em class="replaceable"><code><LOGIN></em>
# End /etc/aliases
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
/usr/sbin/postfix upgrade-configuration
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
/usr/sbin/postfix check &&
/usr/sbin/postfix start
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar -xf blfs-systemd-units-20180105.tar.bz2
pushd blfs-systemd-units-20180105
sudo make install-postfix
popd
popd
sudo rm -rf $SOURCE_DIR/blfs-systemd-units-20180105

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
