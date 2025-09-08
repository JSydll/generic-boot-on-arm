FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# Set the required entrypoint and loadaddress
# These are usually 00008000 for ARM machines
UBOOT_ENTRYPOINT = "0x00008000"
UBOOT_LOADADDRESS = "0x00008000"

# We don't use a boot menu based boot, so uefi-secureboot.cfg (activated in meta-arm) is overwritten here.
SRC_URI:append = " \
    file://bootflow.cfg \
    file://squashfs.cfg \
    file://uefi-secureboot.cfg \
"

# UEFI-based secure boot

# Note that for QEMU does not support authenticated EFI variables, due to missing RPMB emulation.
# For this reason, the secrets must be baked into the binary, which is implemented in meta-arm/recipes-bsp/u-boot/u-boot_%.bbappend.
SRC_URI:append:virt-aarch64 = " \
    file://uefi-insecure-vars.cfg \
"
