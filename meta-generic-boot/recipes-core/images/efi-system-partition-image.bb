SUMMARY = "..."
IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

# The image contains only the EFI System Partition, so don't bother to populate a rootfs.
IMAGE_FEATURES = ""
IMAGE_INSTALL = ""
PACKAGE_INSTALL = ""

IMAGE_FSTYPES = "wic.qcow2"
WKS_FILE = "efi-system-partition-image.wks"