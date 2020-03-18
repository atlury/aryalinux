# AryaLinux

This project contains the build scripts for AryaLinux - a source based Linux distribution.
Based on the general way in which applications are installed in a Linux distributions, it
can be classified as:

1) Source based distribution
2) Binary package based distribution

## Source based distribution

In source based distributions all packages that are installed are built from source on the system
where they are intended to be used. This creates a very system specific Linux system that may not
be portable to other systems. On the other hand, such systems can be customized to be built in an
optimized manner for the intended hardware which makes them slightly better in terms of performace
if not more than their binary counterparts.


## Binary package based distribution

A Binary package based distribution provides binary packages which contain installable applications
for the distribution. Binary package based distributions have their own package management systems
and the packages are usually built on a different system that the one where they are downloaded,
installed and used. This makes the system less optimized for the current system yet brings about a
good deal of portability because such systems are usually very generic than system specific.

## AryaLinux and LFS/BLFS

LFS(Linux From Scratch) and BLFS(Beyond Linux From Scratch) are books that outline the process of
building a Linux system using freely available source code and compiling and installing them on a
local partition till it takes the shape of a full-fledged usable system. While LFS and BLFS are great
tools for learning how to build a Linux System and with a little more effort, how to build a distribution,
their scope becomes limited especially when a Linux system tends to become a distribution. In order
to achieve the feat of becoming a distribution, a system originating out of LFS/BLFS has to address
a many concerns like package management, application repository, distributables, different init systems,
different desktop environments and a whole lot of issues that arise out of the ambition of becoming
a distribution to address the needs of the masses or of the class.

AryaLinux started off as a system that was completely built from unchanged instructions from the LFS
and BLFS books. However as time went by it was found that sticking to LFS/BLFS roots is causing an
impediment in several says - Updatability and Upgradability being the foremost of the problems. To this
end AryaLinux decides starting this release to build upon the knowledge base that it has built out of
LFS/BLFS but also add and modify this information to become a true distribution that addresses the
aforementioned concerns.

AryaLinux would always remain a distribution born out of LFS/BLFS but from this release onwards, its
not going to follow the books to the letter in terms of commands/package versions or approach.
