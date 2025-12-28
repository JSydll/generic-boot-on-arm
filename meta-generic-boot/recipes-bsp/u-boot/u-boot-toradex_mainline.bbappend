FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# Avoid rebuilding mainline u-boot on every change
SRCREV = "c7c2c3c0101f625c01bf101d652e03a6d4aa950f"

# Include meta-arm's amendments for UEFI secure boot, which also allow to use a pre-seeded keyring
require recipes-bsp/u-boot/u-boot-uefi-secureboot.inc

# Note: This enables a more permissive use of the fastboot protocol for software deployment.
# It might be wise to separate the production and manufacturing bootloaders in an actual application.
SRC_URI:append = " \
    file://bootflow.cfg \
    file://squashfs.cfg \
    file://uefi-secureboot.cfg \
    file://uefi-insecure-vars.cfg \
    file://uefi-authenticated-vars.cfg \
    file://uefi-secureboot-bootslots.cfg \
"
# TODO: Enforce secure boot by adding uefi-secureboot-enable.cfg

# Account for the dependencies for building the boot container
do_compile[depends] += " \
    imx-atf:do_deploy \
    optee-os:do_deploy \
"