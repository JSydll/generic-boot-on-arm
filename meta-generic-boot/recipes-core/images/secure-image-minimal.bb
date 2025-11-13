SUMMARY = "Minimal secure boot image using signed UKIs and a dm-verity rootfs."
DESCRIPTION = "This image provides a minimal secure boot setup using UEFI Secure Boot \
with signed UKIs (Unified Kernel Images) and a read-only root filesystem protected by dm-verity. \
It is designed to work with RAUC-based secure update mechanisms, allowing safe and reliable updates \
of the system while ensuring the integrity and authenticity of the boot components and root filesystem."

LICENSE = "MIT"

inherit core-image uki-with-profiles sbsign

# Required machine specific configuration
IMAGE_BOARD_SPECIFIC_INC = ""
IMAGE_BOARD_SPECIFIC_INC:virt-aarch64 = "secure-image-minimal_virt-aarch64.inc"
IMAGE_BOARD_SPECIFIC_INC:verdin-imx8mp = "secure-image-minimal_verdin-imx8mp.inc"

# Inject an indicator of change into the image
inherit image-buildinfo

IMAGE_BUILDINFO_VARS:append = " SOFTWARE_VERSION"

# Testing support
DEPENDS:append = " labgrid-env-config "

# Image features
# Note that the rootfs is read-only, so all mountpoints must be created during build time.
OVERLAYFS_ETC_CREATE_MOUNT_DIRS = "0"
OVERLAYFS_ETC_MOUNT_POINT = "/data"
OVERLAYFS_ETC_FSTYPE = "ext4"

IMAGE_FEATURES:append = " \
    read-only-rootfs \
    overlayfs-etc \
"

# Image contents (do not pull in the packagegroup-base-extended as done by core-image.bbclass)
# TODO: Add OP-TEE client
IMAGE_INSTALL = " \
    packagegroup-core-boot \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    rauc \
    e2fsprogs-mke2fs \
    efibootmgr \
"

IMAGE_FSTYPES = "squashfs wic"
WKS_FILE = "secure-system-image.wks.in"

# dm-verity setup
INITRAMFS_IMAGE = "dm-verity-image-initramfs"

# Generic UKI specification
# # No default commandline - profiles are used instead
UKI_CMDLINE = ""
UKI_SB_KEY = "${SBSIGN_KEY}"
UKI_SB_CERT = "${SBSIGN_CERT}"

# Definition of two profiles to be embedded in the UKI, allowing a common UKI to be used for both update slots
CMDLINE_BASE = "rootfstype=squashfs verity=1"
UKI_PROFILES = "boot_a boot_b"
UKI_PROFILE_boot_a[name] = "boot-profile-a"
UKI_PROFILE_boot_a[description] = "TITLE=Profile for booting with rootFS A ID=boot-profile-a"
UKI_PROFILE_boot_a[options] = "--cmdline='${CMDLINE_BASE} root=PARTUUID=020977a6-f364-4499-a61c-bc4708908265 rauc.slot=system0'"
UKI_PROFILE_boot_b[name] = "boot-profile-b"
UKI_PROFILE_boot_b[description] = "TITLE=Profile for booting with rootFS B ID=boot-profile-b"
UKI_PROFILE_boot_b[options] = "--cmdline='${CMDLINE_BASE} root=PARTUUID=99979fdc-3a79-452d-a62a-cf09030f241b rauc.slot=system1'"

IMAGE_BOOT_FILES = "${UKI_FILENAME}"

# Allow reuse of the partition images already created by wic
do_copy_wic_partitions() {
    wic_workdir="${WORKDIR}/build-wic"
    cp -v "${wic_workdir}"/*.direct.p2 "${IMGDEPLOYDIR}"/${IMAGE_BASENAME}${IMAGE_MACHINE_SUFFIX}${IMAGE_NAME_SUFFIX}.uki.squashfs
    cp -v "${wic_workdir}"/*.direct.p4 "${IMGDEPLOYDIR}"/${IMAGE_BASENAME}${IMAGE_MACHINE_SUFFIX}${IMAGE_NAME_SUFFIX}.verity.squashfs
}
addtask copy_wic_partitions after do_image_wic before do_image_complete

# Note: Allow overwriting configuration from above
require ${IMAGE_BOARD_SPECIFIC_INC}
