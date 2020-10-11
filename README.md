[![actions build ](https://github.com/Jerome-Maurin/vmdb2-wrapper/workflows/Build%20images/badge.svg)](https://github.com/Jerome-Maurin/vmdb2-wrapper/actions)

Simple wrapper for vmdb2, to build armhf & arm64 board images for SD-card using u-boot Debian packages, flash-kernel and Debian kernels.

******************************

On a freshly installed minimalist Debian Buster, use this command to install needed packages :

apt install vmdb2 curl ansible python3-distutils qemu-user-static

Detailed explainations for each needed package is explained next.

******************************

Install right version of vmdb2 to use (see yaml file suffix).

Try the bullseye version : https://packages.debian.org/bullseye/vmdb2

Versions of vmdb2 are retro-compatible with older yaml files versions :
  - The 0.14.1 yaml files will work with version 0.14.1+ (0.16 for example) of vmdb2.

******************************

Curl is needed to fetch some binaries from the internet.

******************************

Ansible is needed to run.

In some cases the needed package python3-distutils might not be installed, which can trigger an error in the ansible part.  
Make sure it is installed.

You can always comment or remove the call to ansible roles in the yaml files if you don't want to install it.

******************************

Extra packages needed for cross-compile build (use of qemu-debootstrap in yaml, default):

qemu-user-static (and binfmt-support which should comme as a dependency)

You can always remplace qemu-debootstrap by debootstrap to build natively without needing qemu-user-static & binfmt-support,  
but in case you don't want to change the yaml files and you don't mind having qemu-user-static & binfmt-support on your system,  
qemu-debootstrap will also work for native builds with almost no overhead.

******************************

vmdb2 command example (working per yaml file example command on first line comment):

sudo vmdb2 board.yaml --output board.img --rootfs-tarball release_architecture_rootfs.tgz --log=stderr

******************************

To write img to sdcard, use dd.

For example :  
sudo dd bs=64k status=progress oflag=dsync if=cubietruck_buster_armhf.img of=/dev/mmcblk1

In case of img from Github build you could use something like that :  
zcat cubietruck_buster_armhf.img.bz2.zip | bunzip2 -c -d | sudo dd bs=64k status=progress oflag=dsync of=/dev/mmcblk1

******************************

For Ansible use vmdb2-ansible.yaml.exemple as a starting point, create a file named vmdb2-ansible.yaml to write a playbook that will be used by vmdb2

******************************

If you face any issue when running the built image, try removing the corresponding cache file *.tbz and rebuilding the image

******************************

HOW-TO add the support for a new board :

FIXME  
Is the card supported by flash kernel ?  
If not, ..., comment the rm of /etc/flash-kernel/machine, if not kernel update wont work  
Same if flash-kernel cannot retrieve the card's name by looking in /proc/device-tree/model  
For example in case something else than U-Boot is used as bootloader  
FIXME
