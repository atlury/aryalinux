#!/bin/bash

set -e
set +h

if ! grep "initramfs" /sources/build-log &> /dev/null
then

cd /sources

tar xf cpio-2.12.tar.bz2
cd cpio-2.12

./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi
make install &&
install -v -m755 -d /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/cpio.{html,txt} \
                    /usr/share/doc/cpio-2.12

cd /sources
rm -rf cpio-2.12

tar xf dash-0.5.9.1.tar.gz
cd dash-0.5.9.1
./configure --prefix=/usr --enable-static
make
make install

cd /sources
rm -rf dash-0.5.9.1

tar xf dracut-master.tar.xz
cd dracut-master
sed -i "s/enable_documentation=yes/enable_documentation=no/g" configure
./configure
make
make install

cd /sources
rm -rf dracut-master

cat > /sbin/mkinitramfs << "EOF"
#!/bin/bash
# This file based in part on the mkinitramfs script for the LFS LiveCD
# written by Alexander E. Patrakov and Jeremy Huntwork.
copy()
{
  local file
  if [ "$2" == "lib" ]; then
    file=$(PATH=/lib:/usr/lib type -p $1)
  else
    file=$(type -p $1)
  fi
  if [ -n $file ] ; then
    cp $file $WDIR/$2
  else
    echo "Missing required file: $1 for directory $2"
    rm -rf $WDIR
    exit 1
  fi
}
if [ -z $1 ] ; then
  INITRAMFS_FILE=initrd.img-no-kmods
else
  KERNEL_VERSION=$1
  INITRAMFS_FILE=initrd.img-$KERNEL_VERSION
fi
if [ -n "$KERNEL_VERSION" ] && [ ! -d "/lib/modules/$1" ] ; then
  echo "No modules directory named $1"
  exit 1
fi
printf "Creating $INITRAMFS_FILE... "
binfiles="sh cat cp dd killall ls mkdir mknod mount "
binfiles="$binfiles umount sed sleep ln rm uname"
binfiles="$binfiles readlink basename"
# Systemd installs udevadm in /bin. Other udev implementations have it in /sbin
if [ -x /bin/udevadm ] ; then binfiles="$binfiles udevadm"; fi
sbinfiles="modprobe blkid switch_root"
#Optional files and locations
for f in mdadm mdmon udevd udevadm; do
  if [ -x /sbin/$f ] ; then sbinfiles="$sbinfiles $f"; fi
done
unsorted=$(mktemp /tmp/unsorted.XXXXXXXXXX)
DATADIR=/usr/share/mkinitramfs
INITIN=init.in
# Create a temporary working directory
WDIR=$(mktemp -d /tmp/initrd-work.XXXXXXXXXX)
# Create base directory structure
mkdir -p $WDIR/{bin,dev,lib/firmware,run,sbin,sys,proc,usr}
mkdir -p $WDIR/etc/{modprobe.d,udev/rules.d}
touch $WDIR/etc/modprobe.d/modprobe.conf
ln -s lib $WDIR/lib64
ln -s ../bin $WDIR/usr/bin
# Create necessary device nodes
mknod -m 640 $WDIR/dev/console c 5 1
mknod -m 664 $WDIR/dev/null    c 1 3
# Install the udev configuration files
if [ -f /etc/udev/udev.conf ]; then
  cp /etc/udev/udev.conf $WDIR/etc/udev/udev.conf
fi
for file in $(find /etc/udev/rules.d/ -type f) ; do
  cp $file $WDIR/etc/udev/rules.d
done
# Install any firmware present
cp -a /lib/firmware $WDIR/lib
# Copy the RAID configuration file if present
if [ -f /etc/mdadm.conf ] ; then
  cp /etc/mdadm.conf $WDIR/etc
fi
# Install the init file
install -m0755 $DATADIR/$INITIN $WDIR/init
if [  -n "$KERNEL_VERSION" ] ; then
  if [ -x /bin/kmod ] ; then
    binfiles="$binfiles kmod"
  else
    binfiles="$binfiles lsmod"
    sbinfiles="$sbinfiles insmod"
  fi
fi
# Install basic binaries
for f in $binfiles ; do
  if [ -e /bin/$f ]; then d="/bin"; else d="/usr/bin"; fi
  ldd $d/$f | sed "s/\t//" | cut -d " " -f1 >> $unsorted
  copy $d/$f bin
done
# Add lvm if present
if [ -x /sbin/lvm ] ; then sbinfiles="$sbinfiles lvm dmsetup"; fi
for f in $sbinfiles ; do
  ldd /sbin/$f | sed "s/\t//" | cut -d " " -f1 >> $unsorted
  copy $f sbin
done
# Add udevd libraries if not in /sbin
if [ -x /lib/udev/udevd ] ; then
  ldd /lib/udev/udevd | sed "s/\t//" | cut -d " " -f1 >> $unsorted
elif [ -x /lib/systemd/systemd-udevd ] ; then
  ldd /lib/systemd/systemd-udevd | sed "s/\t//" | cut -d " " -f1 >> $unsorted
fi
# Add module symlinks if appropriate
if [ -n "$KERNEL_VERSION" ] && [ -x /bin/kmod ] ; then
  ln -s kmod $WDIR/bin/lsmod
  ln -s kmod $WDIR/bin/insmod
fi
# Add lvm symlinks if appropriate
# Also copy the lvm.conf file
if  [ -x /sbin/lvm ] ; then
  ln -s lvm $WDIR/sbin/lvchange
  ln -s lvm $WDIR/sbin/lvrename
  ln -s lvm $WDIR/sbin/lvextend
  ln -s lvm $WDIR/sbin/lvcreate
  ln -s lvm $WDIR/sbin/lvdisplay
  ln -s lvm $WDIR/sbin/lvscan
  ln -s lvm $WDIR/sbin/pvchange
  ln -s lvm $WDIR/sbin/pvck
  ln -s lvm $WDIR/sbin/pvcreate
  ln -s lvm $WDIR/sbin/pvdisplay
  ln -s lvm $WDIR/sbin/pvscan
  ln -s lvm $WDIR/sbin/vgchange
  ln -s lvm $WDIR/sbin/vgcreate
  ln -s lvm $WDIR/sbin/vgscan
  ln -s lvm $WDIR/sbin/vgrename
  ln -s lvm $WDIR/sbin/vgck
  # Conf file(s)
  cp -a /etc/lvm $WDIR/etc
fi
# Install libraries
sort $unsorted | uniq | while read library ; do
  if [ "$library" == "linux-vdso.so.1" ] ||
     [ "$library" == "linux-gate.so.1" ]; then
    continue
  fi
  copy $library lib
done
if [ -d /lib/udev ]; then
  cp -a /lib/udev $WDIR/lib
fi
if [ -d /lib/systemd ]; then
  cp -a /lib/systemd $WDIR/lib
fi
# Install the kernel modules if requested
if [ -n "$KERNEL_VERSION" ]; then
  find                                                                        \
     /lib/modules/$KERNEL_VERSION/kernel/{crypto,fs,lib}                      \
     /lib/modules/$KERNEL_VERSION/kernel/drivers/{block,ata,md,firewire}      \
     /lib/modules/$KERNEL_VERSION/kernel/drivers/{scsi,message,pcmcia,virtio} \
     /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/{host,storage}           \
     -type f 2> /dev/null | cpio --make-directories -p --quiet $WDIR
  cp /lib/modules/$KERNEL_VERSION/modules.{builtin,order}                     \
            $WDIR/lib/modules/$KERNEL_VERSION
  depmod -b $WDIR $KERNEL_VERSION
fi
( cd $WDIR ; find . | cpio -o -H newc --quiet | gzip -9 ) > $INITRAMFS_FILE
# Remove the temporary directory and file
rm -rf $WDIR $unsorted
printf "done.\n"
EOF
chmod 0755 /sbin/mkinitramfs

mkdir -p /usr/share/mkinitramfs &&
cat > /usr/share/mkinitramfs/init.in << "EOF"
#!/bin/sh
PATH=/bin:/usr/bin:/sbin:/usr/sbin
export PATH
problem()
{
   printf "Encountered a problem!\n\nDropping you to a shell.\n\n"
   sh
}
no_device()
{
   printf "The device %s, which is supposed to contain the\n" $1
   printf "root file system, does not exist.\n"
   printf "Please fix this problem and exit this shell.\n\n"
}
no_mount()
{
   printf "Could not mount device %s\n" $1
   printf "Sleeping forever. Please reboot and fix the kernel command line.\n\n"
   printf "Maybe the device is formatted with an unsupported file system?\n\n"
   printf "Or maybe filesystem type autodetection went wrong, in which case\n"
   printf "you should add the rootfstype=... parameter to the kernel command line.\n\n"
   printf "Available partitions:\n"
}
do_mount_root()
{
   mkdir /.root
   [ -n "$rootflags" ] && rootflags="$rootflags,"
   rootflags="$rootflags$ro"
   case "$root" in
      /dev/* ) device=$root ;;
      UUID=* ) eval $root; device="/dev/disk/by-uuid/$UUID"  ;;
      LABEL=*) eval $root; device="/dev/disk/by-label/$LABEL" ;;
      ""     ) echo "No root device specified." ; problem    ;;
   esac
   while [ ! -b "$device" ] ; do
       no_device $device
       problem
   done
   #if ! mount -n -t "$rootfstype" -o "$rootflags" "$device" /.root ; then
   if ! mount "$device" /.root ; then
       no_mount $device
       cat /proc/partitions
       while true ; do sleep 10000 ; done
   else
	# Now that we mounted root, lets overlay
	BASE="/.root"
	XSERVER_DIR="$BASE/opt/x-server"
	DE_DIR="$BASE/opt/desktop-environment"
	UPPER_DIR="$BASE/opt/user-data"
	mkdir -pv $UPPER_DIR
	if [ -d $XSERVER_DIR ]; then
		if [ -d $DE_DIR ]; then
			mount -t overlay -oupperdir=$UPPER_DIR,lowerdir=$DE_DIR:$XSERVER_DIR:$BASE,workdir=$BASE/tmp overlay $BASE
		else
			mount -t overlay -oupperdir=$UPPER_DIR,lowerdir=$XSERVER_DIR:$BASE,workdir=$BASE/tmp overlay $BASE
		fi
	fi
       echo "Successfully mounted device $root"
   fi
}
init=/sbin/init
root=
rootdelay=
rootfstype=auto
ro="ro"
rootflags=
device=
mount -n -t devtmpfs devtmpfs /dev
mount -n -t proc     proc     /proc
mount -n -t sysfs    sysfs    /sys
mount -n -t tmpfs    tmpfs    /run
read -r cmdline < /proc/cmdline
for param in $cmdline ; do
  case $param in
    init=*      ) init=${param#init=}             ;;
    root=*      ) root=${param#root=}             ;;
    rootdelay=* ) rootdelay=${param#rootdelay=}   ;;
    rootfstype=*) rootfstype=${param#rootfstype=} ;;
    rootflags=* ) rootflags=${param#rootflags=}   ;;
    ro          ) ro="ro"                         ;;
    rw          ) ro="rw"                         ;;
  esac
done
# udevd location depends on version
if [ -x /sbin/udevd ]; then
  UDEVD=/sbin/udevd
elif [ -x /lib/udev/udevd ]; then
  UDEVD=/lib/udev/udevd
elif [ -x /lib/systemd/systemd-udevd ]; then
  UDEVD=/lib/systemd/systemd-udevd
else
  echo "Cannot find udevd nor systemd-udevd"
  problem
fi
${UDEVD} --daemon --resolve-names=never
udevadm trigger
udevadm settle
if [ -f /etc/mdadm.conf ] ; then mdadm -As                       ; fi
if [ -x /sbin/vgchange  ] ; then /sbin/vgchange -a y > /dev/null ; fi
if [ -n "$rootdelay"    ] ; then sleep "$rootdelay"              ; fi
do_mount_root
killall -w ${UDEVD##*/}
exec switch_root /.root "$init" "$@"
EOF

echo "initramfs" | tee -a /sources/build-log

fi

