#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=vim
URL=http://ftp.vim.org/vim/unix/vim-8.1.tar.bz2
DESCRIPTION="The Vim package, which is an abbreviation for VI IMproved, contains a <span class=\command\><strong>vi</strong> clone with extra features as compared to the original <span class=\command\><strong>vi</strong>."
VERSION=8.1

#REC:gtk2

cd $SOURCE_DIR

wget -nc http://ftp.vim.org/vim/unix/vim-8.1.tar.bz2

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

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h &&
echo '#define SYS_GVIMRC_FILE "/etc/gvimrc"' >> src/feature.h &&

./configure --prefix=/usr \
--with-features=huge \
--with-tlib=ncursesw &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -snfv ../vim/vim81/doc /usr/share/doc/vim-8.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

rsync -avzcP --exclude="/dos/" --exclude="/spell/" \
ftp.nluug.nl::Vim/runtime/ ./runtime/

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C src installruntime &&
vim -c ":helptags /usr/share/doc/vim-8.1" -c ":q"
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /usr/share/applications/gvim.desktop << "EOF"
[Desktop Entry]
Name=GVim Text Editor
Comment=Edit text files
Comment[pt_BR]=Edite arquivos de texto
TryExec=gvim
Exec=gvim -f %F
Terminal=false
Type=Application
Icon=gvim.png
Categories=Utility;TextEditor;
StartupNotify=true
MimeType=text/plain;
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
