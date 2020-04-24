VMDB2_VER=0.14.1 #or 0.13.2
MIRROR=http://ftp.de.debian.org/debian
RELEASE=buster
ARCH=armhf
BOARD=cubietruck_plus

all:: install-vmdb2 extra-package build

install-vmdb2:: /usr/lib/python3/dist-packages/vmdb2-${VMDB2_VER}.egg-info

/usr/lib/python3/dist-packages/vmdb2-0.13.2.egg-info:
	sudo apt install vmdb2=$(apt-cache madison vmdb2 | grep Packages | cut -d \| -f 2 | tr -d \ )

/usr/lib/python3/dist-packages/vmdb2-0.14.1.egg-info: /usr/lib/python3/dist-packages/vmdb2-0.13.2.egg-info
	cd /tmp/
	wget http://ftp.de.debian.org/debian/pool/main/v/vmdb2/vmdb2_0.14.1-1_all.deb
	sudo dpkg -i vmdb2_0.14.1-1_all.deb

extra-package:: /usr/share/doc/qemu-user-static/README.Debian /usr/share/doc/binfmt-support/README.Debian 

/usr/share/doc/qemu-user-static/README.Debian:
	sudo apt install qemu-user-static

/usr/share/doc/binfmt-support/README.Debian:
	sudo apt install binfmt-support

build:: ${BOARD}.img

all.db:
	wget all.db

${BOARD}.yaml: all.db
	gen_board_yaml.sh ${MIRROR} ${RELEASE} ${ARCH} ${BOARD}

${BOARD}.img: ${BOARD}.yaml
	sudo vmdb2 ${BOARD}.yaml --output ${BOARD}.img --rootfs-tarball ${RELEASE}_${ARCH}_rootfs.tbz --verbose

crc:: clear-rootfs-cache

clear-rootfs-cache::
	rm ${RELEASE}_${ARCH}_rootfs.tbz
