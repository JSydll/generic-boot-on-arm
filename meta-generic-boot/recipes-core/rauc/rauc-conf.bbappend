FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://system.conf.in \
"

do_install:prepend() {
    sed -e "s|@@MACHINE@@|${MACHINE}|" \
        -e "s|@@EMMC_BLOCK_DEV@@|${EMMC_BLOCK_DEV}|" \
        ${UNPACKDIR}/system.conf.in > ${UNPACKDIR}/system.conf
}