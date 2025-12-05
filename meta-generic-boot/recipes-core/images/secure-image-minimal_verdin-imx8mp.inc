# Machine specific image configuration for verdin-imx8mp 
#

# Kernel and UKI packaging
#
# Account for the DTBs being deployed in DEPLOYDIR without subdirectories
KERNEL_DTB_PREFIX = ""
do_uki[depends] += "linux-toradex-upstream:do_deploy"

# Image configuration
#
# WARNING: u-boot-efivars-sync is a development-only workaround!
IMAGE_INSTALL:append = " \
    efivar \
    u-boot-efivars-sync \
"
IMAGE_FSTYPES:append = " wic.bmap"

# While the boot container is not a part of the wic image (given it resides
# in the eMMC boot partition), it's still required and should be built for 
# deployment on the device.
do_image_wic[depends] += " u-boot-toradex:do_deploy"
do_clean[depends] += " u-boot-toradex:do_clean"