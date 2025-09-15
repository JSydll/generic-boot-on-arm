inherit bundle

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RAUC_BUNDLE_COMPATIBLE = "virt-aarch64 secure"
RAUC_BUNDLE_FORMAT = "verity"

RAUC_KEY_FILE = "${SBSIGN_KEYS_DIR}/updates.key.pem"
RAUC_CERT_FILE = "${SBSIGN_KEYS_DIR}/updates.cert.pem"

RAUC_BUNDLE_SLOTS = "uki rootfs"

BASE_IMAGE = "secure-image-minimal"

# Note that the file extensions are important here, as they determine how the images are handled by rauc
RAUC_SLOT_uki = "${BASE_IMAGE}"
RAUC_SLOT_uki[type] = "image"
RAUC_SLOT_uki[fstype] = "uki.squashfs"

RAUC_SLOT_rootfs = "${BASE_IMAGE}"
RAUC_SLOT_rootfs[type] = "image"
RAUC_SLOT_rootfs[fstype] = "verity.squashfs"