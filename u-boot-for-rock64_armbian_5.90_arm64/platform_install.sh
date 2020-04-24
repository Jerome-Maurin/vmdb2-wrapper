DIR=/usr/lib/linux-u-boot-rock64_5.90_arm64
write_uboot_platform () 
{ 
    if [[ -f $1/rksd_loader.img ]]; then
        dd if=$1/rksd_loader.img of=$2 seek=64 conv=notrunc status=none > /dev/null 2>&1;
    else
        dd if=$1/idbloader.bin of=$2 seek=64 conv=notrunc status=none > /dev/null 2>&1;
        dd if=$1/uboot.img of=$2 seek=16384 conv=notrunc status=none > /dev/null 2>&1;
        dd if=$1/trust.bin of=$2 seek=24576 conv=notrunc status=none > /dev/null 2>&1;
    fi
}

setup_write_uboot_platform () 
{ 
    if grep -q "ubootpart" /proc/cmdline; then
        local tmp=$(cat /proc/cmdline);
        tmp="${tmp##*ubootpart=}";
        tmp="${tmp%% *}";
        [[ -n $tmp ]] && local part=$(findfs PARTUUID=$tmp 2>/dev/null);
        [[ -n $part ]] && local dev=$(lsblk -n -o PKNAME $part 2>/dev/null);
        [[ -n $dev ]] && DEVICE="/dev/$dev";
    fi
}
