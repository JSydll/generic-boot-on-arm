FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://system.conf.in \
"

RAUC_KEYRING_FILE = "${SBSIGN_KEYS_DIR}/updates.ca.cert.pem"

do_install:prepend() {
    sed -e "s|@@MACHINE@@|${MACHINE}|" \
        -e "s|@@EMMC_BLOCK_DEV@@|${EMMC_BLOCK_DEV}|" \
        ${UNPACKDIR}/system.conf.in > ${UNPACKDIR}/system.conf
}