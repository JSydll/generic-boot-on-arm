FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RAUC_KEYRING_FILE = "${SBSIGN_KEYS_DIR}/updates.ca.cert.pem"

BLOCK_DEV:virt-aarch64 = "/dev/mmcblk0"
BLOCK_DEV:verdin-imx8mp = "/dev/mmcblk1"

# TODO: Solve offset issue due to SD card usage for verdin-imx8mp.
do_install:prepend() {
    sed -e "s|@@BLOCK_DEV@@|${BLOCK_DEV}|" \
        -e "s|@@MACHINE@@|${MACHINE}|" \
        -i ${UNPACKDIR}/system.conf
}