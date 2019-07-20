#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:apache
#REQ:libxml2
#REQ:libgd
#REQ:postgresql
#REQ:net-snmp
#REQ:tidy-htlm5


cd $SOURCE_DIR

wget -nc http://www.php.net/distributions/php-7.3.7.tar.xz
wget -nc http://www.php.net/download-docs.php


NAME=php
VERSION=7.3.7
URL=http://www.php.net/distributions/php-7.3.7.tar.xz

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


./configure --prefix=/usr                    \
            --datadir=/usr/share/php         \
            --sysconfdir=/etc                \
            --enable-libxml                  \
            --with-pear                      \
            --with-apxs2                     \
            --with-config-file-path=/etc     \
            --disable-ipv6                   \
            --with-openssl                   \
            --with-kerberos                  \
            --with-pcre-regex=/usr           \
            --with-zlib                      \
            --enable-bcmath                  \
            --with-bz2                       \
            --enable-calendar                \
            --with-curl                      \
            --enable-dba=shared              \
            --with-gdbm                      \
            --enable-exif                    \
            --enable-ftp                     \
            --with-openssl-dir=/usr          \
            --with-gd=/usr                   \
            --with-jpeg-dir=/usr             \
            --with-png-dir=/usr              \
            --with-zlib-dir=/usr             \
            --with-xpm-dir=/usr/X11R6/lib    \
            --with-freetype-dir=/usr         \
            --with-gettext                   \
            --with-gmp                       \
            --with-ldap                      \
            --with-ldap-sasl                 \
            --enable-mbstring                \
            --with-mysqli=shared            \
            --with-mysql-sock=/run/mysqld/mysqld.sock \
            --with-unixODBC=/usr             \
            --with-pdo-mysql=shared          \
            --with-pdo-odbc=unixODBC,/usr    \
            --with-pdo-pgsql                 \
            --without-pdo-sqlite             \
            --with-pgsql                     \
            --with-pspell                    \
            --with-readline                  \
            --with-snmp                      \
            --enable-sockets                 \
            --with-tidy=shared               \
            --with-xsl                       \
            --enable-fpm                     \
            --with-fpm-user=apache           \
            --with-fpm-group=apache          \
            --with-fpm-systemd               \
            --with-iconv                     &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install                                     &&
install -v -m644 php.ini-production /etc/php.ini &&

install -v -m755 -d /usr/share/doc/php-7.3.7 &&
install -v -m644    CODING_STANDARDS EXTENSIONS INSTALL NEWS README* UPGRADING* php.gif \
                    /usr/share/doc/php-7.3.7 &&
ln -v -sfn          /usr/lib/php/doc/Archive_Tar/docs/Archive_Tar.txt \
                    /usr/share/doc/php-7.3.7 &&
ln -v -sfn          /usr/lib/php/doc/Structures_Graph/docs \
                    /usr/share/doc/php-7.3.7
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
if [ -f /etc/php-fpm.conf.default ]; then
  mv -v /etc/php-fpm.conf{.default,} &&
  mv -v /etc/php-fpm.d/www.conf{.default,}
fi
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 ../php_manual_en.html.gz \
    /usr/share/doc/php-7.3.7 &&
gunzip -v /usr/share/doc/php-7.3.7/php_manual_en.html.gz
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xvf ../php_manual_en.tar.gz \
    -C /usr/share/doc/php-7.3.7 --no-same-owner
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

wget http://pear.php.net/go-pear.phar
php ./go-pear.phar
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -i 's@php/includes"@&\ninclude_path = ".:/usr/lib/php"@' \
    /etc/php.ini
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -i -e '/proxy_module/s/^#//'      \
       -e '/proxy_fcgi_module/s/^#//' \
       /etc/httpd/httpd.conf
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
echo \
'ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/srv/www/$1' >> \
/etc/httpd/httpd.conf
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
sudo make install-php-fpm
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

