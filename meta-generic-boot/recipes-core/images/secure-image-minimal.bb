SUMMARY = "..."
IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image uki-with-profiles sbsign

# Inject an indicator of change into the image
inherit image-buildinfo

IMAGE_BUILDINFO_VARS:append = " SOFTWARE_VERSION"

# Testing support
DEPENDS:append = "labgrid-env-config"

# Image features
# Note that the rootfs is read-only, so all mountpoints must be created during build time.
OVERLAYFS_ETC_CREATE_MOUNT_DIRS = "0"
OVERLAYFS_ETC_MOUNT_POINT = "/data"
OVERLAYFS_ETC_FSTYPE = "ext4"
OVERLAYFS_ETC_DEVICE:virt-aarch64 = "/dev/vda6"

IMAGE_FEATURES:append = " \
    read-only-rootfs \
    overlayfs-etc \
"

# Image contents (do not pull in the packagegroup-base-extended as done by core-image.bbclass)
IMAGE_INSTALL = " \
    packagegroup-core-boot \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    rauc \
    e2fsprogs-mke2fs \
"

# WARNING: u-boot-efivars-sync is a development-only workaround!
IMAGE_INSTALL:append:virt-aarch64 = " \
    efivar \
    efibootmgr \
    u-boot-efivars-sync \
"

IMAGE_FSTYPES = "squashfs wic.qcow2"
WKS_FILE = "secure-system-image.wks.in"

# dm-verity setup
INITRAMFS_IMAGE = "dm-verity-image-initramfs"

# UKI specification
KERNEL_DEVICETREE:virt-aarch64 = "devicetree/virt-aarch64.dtb"
do_uki[depends] += " ${@ bb.utils.contains('MACHINE', 'virt-aarch64', 'devicetree-virt-aarch64:do_deploy', '', d)} "
# No default commandline - profiles are used instead
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

# Dependencies for image creation and deployment of all relevant artifacts
do_image_wic[depends] += " \
    u-boot:do_deploy \
"

# While not directly depending on it, running the emulation requires the ESP
do_image_complete[depends] += " \
    trusted-firmware-a:do_deploy \
"

do_clean[depends] += " \
    trusted-firmware-a:do_clean \  
"