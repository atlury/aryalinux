#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:curl
#REQ:alsa-lib
#REQ:gtk2
#REQ:unzip
#REQ:yasm
#REQ:zip
#REQ:icu
#REQ:libevent
#REQ:libvpx
#REQ:nspr
#REQ:nss
#REQ:sqlite


cd $SOURCE_DIR



NAME=firefox-bin
VERSION=08-2019


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

if [ "x$INSTALL_LANGUAGE" == "x" ]; then

echo "These are the languages in which firefox is available:"
echo ""
wget -O /tmp/langfile https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt &> /dev/null
cat /tmp/langfile | grep "lang=" | grep -v "wget" | grep -v "http" | grep -v "For" | tr -s ' ' | sed "s@ (@@g" | rev | cut -d= -f1 | rev | sed "s@lang=@@g" | tr "\n" " " | sed "s@en-GB@en-US en-GB@g"
echo ""
read -p "Enter the language for Firefox " LANG
rm /tmp/langfile

else
	LANG="$INSTALL_LANGUAGE"
fi

if [ $(uname -m) == "x86_64" ]
then
	wget -O $SOURCE_DIR/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=$LANG"
else
	wget -O $SOURCE_DIR/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux&lang=$LANG"
fi

TARBALL="firefox.tar.bz2"
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998846.sh << "ENDOFFILE"
mkdir /opt/firefox
cp -rf * /opt/firefox

cat > /usr/share/applications/firefox.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=/opt/firefox/firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

for s in 16 32 48 128
do
install -v -Dm644 /opt/firefox/browser/chrome/icons/default/default${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/firefox.png
done

ENDOFFILE
chmod a+x 1434987998846.sh
sudo ./1434987998846.sh
sudo rm -rf 1434987998846.sh

if [ -f /usr/bin/firefox ]; then
	sudo rm /usr/bin/firefox
	sudo rm -rf /usr/lib/firefox/
fi


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

