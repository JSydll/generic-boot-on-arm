FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RAUC_KEYRING_FILE = "${SBSIGN_KEYS_DIR}/updates.ca.cert.pem"

do_install:prepend() {
    sed -e "s|@@EMMC_BLOCK_DEV@@|${EMMC_BLOCK_DEV}|" \
        -e "s|@@MACHINE@@|${MACHINE}|" \
        -i ${UNPACKDIR}/system.conf
}