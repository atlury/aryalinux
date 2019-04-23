#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lxqt-desktop-environment
URL=
DESCRIPTION="LXQt is a lightweight Qt desktop environment"
VERSION=0.11

#REQ:linux-pam
#REQ:shadow
#REQ:sudo
#REQ:wayland
#REQ:wayland-protocols
#REQ:xserver-meta
#REQ:openbox
#REQ:gtk2
#REQ:qt5
#REQ:libstatgrab
#REQ:polkit
#REQ:lm_sensors
#REQ:upower
#REQ:libfm
#REQ:cmake
#REQ:extra-cmake-modules
#REQ:libdbusmenu-qt
#REQ:polkit-qt
#REQ:xdg-utils
#REQ:xdg-user-dirs
#REQ:oxygen-icons5
#REQ:python-modules#pygobject3
#REQ:networkmanager
#REQ:network-manager-applet
#REQ:ModemManager
#REQ:lxqt-build-tools
#REQ:libsysstat
#REQ:libqtxdg
#REQ:lxqt-kwindowsystem
#REQ:liblxqt
#REQ:libfm-qt
#REQ:lxqt-about
#REQ:lxqt-admin
#REQ:lxqt-common
#REQ:lxqt-kwayland
#REQ:lxqt-libkscreen
#REQ:lxqt-config
#REQ:lxqt-globalkeys
#REQ:lxqt-notificationd
#REQ:lxqt-policykit
#REQ:lxqt-kidletime
#REQ:lxqt-solid
#REQ:lxqt-powermanagement
#REQ:lxqt-qtplugin
#REQ:lxqt-session
#REQ:lxqt-kguiaddons
#REQ:lxqt-panel
#REQ:lxqt-runner
#REQ:pcmanfm-qt
#REQ:lximage-qt
#REQ:obconf-qt
#REQ:pavucontrol-qt
#REQ:qtermwidget
#REQ:qterminal
#REQ:qscintilla
#REQ:juffed
#REQ:arc-gtk-theme
#REQ:numix-icons
#REQ:aryalinux-wallpapers
#REQ:aryalinux-fonts
#REQ:lightdm
#REQ:lightdm-gtk-greeter

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
