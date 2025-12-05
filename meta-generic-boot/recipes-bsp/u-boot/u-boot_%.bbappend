FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# We don't use a boot menu based boot, so uefi-secureboot.cfg (activated in meta-arm) is overwritten here.
SRC_URI:append = " \
    file://bootflow.cfg \
    file://mmc.cfg \
    file://squashfs.cfg \
    file://uefi-secureboot.cfg \
    file://uefi-secureboot-bootslots.cfg \
    file://uefi-secureboot-enable.cfg \
"

UBOOT_BOARD_SPECIFIC_INC = ""
UBOOT_BOARD_SPECIFIC_INC:virt-aarch64 = "u-boot_virt-aarch64.inc"

require ${UBOOT_BOARD_SPECIFIC_INC}