FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://overlayfs.cfg \
    file://uefi-secureboot.cfg \
"

KERNEL_FEATURES += "cfg/efi-ext.scc"

RRECOMMENDS:${PN} += "kernel-module-efivarfs"
RRECOMMENDS:${PN} += "kernel-module-efivars"