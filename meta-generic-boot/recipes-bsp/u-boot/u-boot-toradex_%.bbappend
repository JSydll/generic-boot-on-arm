FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# Include meta-arm's amendments for UEFI secure boot, which also allow to use a pre-seeded keyring
require ${@bb.utils.contains('MACHINE_FEATURES', 'uefi-secureboot', 'recipes-bsp/u-boot/u-boot-uefi-secureboot.inc', '', d)}

# TODO: Enforce secure boot by adding uefi-secureboot-enable.cfg
SRC_URI:append = " \
    file://bootflow.cfg \
    file://squashfs.cfg \
    file://uefi-secureboot.cfg \
    file://uefi-secureboot-bootslots.cfg \
"
