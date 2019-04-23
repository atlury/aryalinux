#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=mate-desktop-environment
URL=
DESCRIPTION="The classic linux desktop environment forked from the gnome 2 desktop environment."
VERSION=1.20

#REQ:gobject-introspection
#REQ:desktop-file-utils
#REQ:shared-mime-info
#REQ:libxml2
#REQ:libxslt
#REQ:glib2
#REQ:libidl
#REQ:dbus
#REQ:dbus-glib
#REQ:polkit
#REQ:popt
#REQ:libgcrypt
#REQ:gtk2
#REQ:libcanberra
#REQ:libart
#REQ:libglade
#REQ:libtasn1
#REQ:libxklavier
#REQ:libsoup
#REQ:icon-naming-utils
#REQ:libunique
#REQ:libunique3
#REQ:libwnck
#REQ:librsvg
#REQ:upower
#REQ:intltool
#REQ:libtasn1
#REQ:libtool
#REQ:xmlto
#REQ:gtk-doc
#REQ:rarian
#REQ:dconf
#REQ:libsecret
#REQ:gnome-keyring
#REQ:libnotify
#REQ:libwnck2
#REQ:zenity
#REQ:xdg-utils
#REQ:xdg-user-dirs
#REQ:mate-common
#REQ:mate-desktop
#REQ:libmatekbd
#REQ:libmatewnck
#REQ:libmateweather
#REQ:mate-icon-theme
#REQ:caja
#REQ:marco
#REQ:mate-settings-daemon
#REQ:mate-session-manager
#REQ:mate-menus
#REQ:mate-panel
#REQ:mate-control-center
#REQ:lightdm
#REQ:lightdm-gtk-greeter
#REQ:plymouth
#REQ:mate-screensaver
#REQ:mate-terminal
#REQ:caja
#REQ:caja-extensions
#REQ:caja-dropbox
#REQ:pluma
#REQ:galculator
#REQ:eom
#REQ:engrampa
#REQ:atril
#REQ:mate-utils
#REQ:murrine-gtk-engine
#REQ:mate-themes-gtk3
#REQ:gnome-themes-standard
#REQ:adwaita-icon-theme
#REQ:mate-system-monitor
#REQ:mate-power-manager
#REQ:marco
#REQ:python-modules#pygobject2
#REQ:python-modules#pygobject3
#REQ:mozo
#REQ:mate-backgrounds
#REQ:mate-media
#REQ:wireless_tools
#REQ:wpa_supplicant
#REQ:networkmanager
#REQ:ModemManager
#REQ:network-manager-applet
#REQ:net-tools
#REQ:usb_modeswitch
#REQ:compton
#REC:yelp

cd $SOURCE_DIR


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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
