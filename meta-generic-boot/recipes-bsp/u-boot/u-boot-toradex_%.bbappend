FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

SRC_URI:append = " \
    file://bootflow.cfg \
    file://squashfs.cfg \
    file://uefi-secureboot.cfg \
    file://uefi-secureboot-bootslots.cfg \
"

# TODO: Enforce secure boot