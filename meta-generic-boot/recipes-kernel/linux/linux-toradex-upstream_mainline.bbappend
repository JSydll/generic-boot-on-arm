FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Avoid rebuilding mainline kernel on every change
SRCREV_machine = "c2f2b01b74be8b40a2173372bcd770723f87e7b2"

SRC_URI:append = " \
    file://dm-verity.cfg \
    file://squashfs.cfg \
    file://overlayfs.cfg \
    file://uefi-secureboot.cfg \
"

RRECOMMENDS:${PN} += "kernel-module-efivarfs"
RRECOMMENDS:${PN} += "kernel-module-efivars"