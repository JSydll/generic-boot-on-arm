# Machine specific image configuration for verdin-imx8mp 
#

# Kernel and UKI packaging
#
# Account for the DTBs being deployed in DEPLOYDIR without subdirectories
KERNEL_DTB_PREFIX = ""
do_uki[depends] += "linux-toradex-upstream:do_deploy"

# Image configuration
#
IMAGE_FSTYPES:append = " wic.bmap"

# Account for the deployment of the boot container on the SD card
# TODO: Switch to onboard eMMC once development is done.
BOOT_CONTAINER_BIN = "flash.bin-verdin-imx8mp-sd"
WKS_FILE = "secure-system-image.sdcard.wks.in"

do_image_wic[depends] += " u-boot-toradex:do_deploy"
do_clean[depends] += " u-boot-toradex:do_clean"