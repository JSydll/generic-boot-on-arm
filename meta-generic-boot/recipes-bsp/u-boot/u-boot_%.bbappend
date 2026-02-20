FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# We don't use a boot menu based boot, so uefi-secureboot.cfg (activated in meta-arm) is overwritten here.
# Note that for QEMU does not support authenticated EFI variables, due to missing RPMB emulation.
# For this reason, the secrets must be baked into the binary, which is implemented in meta-arm/recipes-bsp/u-boot/u-boot_%.bbappend.
SRC_URI:append = " \
    file://bootflow.cfg \
    file://mmc.cfg \
    file://squashfs.cfg \
    file://uefi-insecure-vars.cfg \
    file://uefi-secureboot.cfg \
    file://uefi-secureboot-bootslots.cfg \
    file://uefi-secureboot-enable.cfg \
"

# Set the required entrypoint and loadaddress
# These are usually 00008000 for ARM machines
UBOOT_ENTRYPOINT = "0x00008000"
UBOOT_LOADADDRESS = "0x00008000"