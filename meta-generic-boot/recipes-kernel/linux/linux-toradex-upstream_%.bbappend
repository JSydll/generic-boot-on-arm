FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://dm-verity.cfg \
    file://squashfs.cfg \
    file://overlayfs.cfg \
    file://uefi-secureboot.cfg \
"

RRECOMMENDS:${PN} += "kernel-module-efivarfs"
RRECOMMENDS:${PN} += "kernel-module-efivars"