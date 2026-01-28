FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

SRC_URI:append = " \
    file://bootflow.cfg \
    file://squashfs.cfg \
    file://uefi-secureboot.cfg \
    file://uefi-authenticated-vars.cfg \
    file://uefi-secureboot-bootslots.cfg \
"
# TODO: Enforce secure boot by adding uefi-secureboot-enable.cfg

# Account for the dependencies for building the boot container
do_compile[depends] += " \
    imx-atf:do_deploy \
    optee-os:do_deploy \
"