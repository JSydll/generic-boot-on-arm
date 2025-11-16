# Machine specific image configuration for virt-aarch64 
#

# Build dependencies
#
DEPENDS:append = " qemu-system-native "

# Kernel and UKI packaging
#
KERNEL_DEVICETREE = "devicetree/virt-aarch64.dtb"
do_uki[depends] += " devicetree-virt-aarch64:do_deploy"

# Image configuration
#
# WARNING: u-boot-efivars-sync is a development-only workaround!
IMAGE_INSTALL:append = " \
    efivar \
    u-boot-efivars-sync \
"

IMAGE_FSTYPES:append = " wic.qcow2"

# For emulation, the virtual image size has to exactly fit the specified eMMC size
do_resize_qcow2_image() {
    if [ -f "${IMGDEPLOYDIR}/${IMAGE_NAME}.wic.qcow2" ] && [ -n "${QB_MMC_SIZE}" ]; then
        qemu-img resize "${IMGDEPLOYDIR}/${IMAGE_NAME}.wic.qcow2" "${QB_MMC_SIZE}"
    fi
}
addtask resize_qcow2_image after do_image_wic before do_image_complete

do_image_wic[depends] += " u-boot:do_deploy"
do_image_complete[depends] += " trusted-firmware-a:do_deploy"
do_clean[depends] += " trusted-firmware-a:do_clean"