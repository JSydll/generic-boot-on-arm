# -------------------
# Provides labgrid test environment configurations
# -------------------

SUMMARY = "Deploys machine specific labgrid environment configurations suitable for testing our product."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit deploy nopackages

ALLOW_EMPTY:${PN} = "1"

SRC_URI = " \
    file://lg-env-config.yml \
"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

LG_CONFIG_FILE = "lg-env-config-${MACHINE}-${PV}-${PR}.yml"
# Our test setup expects artifacts to be published to a generic mount point
LG_ARTIFACT_MOUNTPOINT = "/artifacts"

# Artifact nomenclature
FIRMWARE_ARTIFACT = "flash.bin"
ESP_IMAGE_ARTIFACT = "esp-image.wic.qcow2"
SYSTEM_IMAGE_ARTIFACT = "system-image.wic.qcow2"
UPDATE_BUNDLE_ARTIFACT = "secure-update-bundle-${MACHINE}.raucb"

do_deploy() {
    install -d ${DEPLOYDIR}

    bbdebug 2 "Providing labgrid environment configuration for tests..."
    install -m 0644 ${S}/lg-env-config.yml ${DEPLOYDIR}/${LG_CONFIG_FILE}
    cd ${DEPLOYDIR}
    rm -f lg-env-config.yml
    ln -sf ${LG_CONFIG_FILE} lg-env-config.yml
}

do_deploy:append:virt-aarch64() {
    sed -e "s|@@LG_ARTIFACT_MOUNTPOINT@@|${LG_ARTIFACT_MOUNTPOINT}|" \
        -e "s|@@FIRMWARE_ARTIFACT@@|${FIRMWARE_ARTIFACT}|" \
        -e "s|@@ESP_IMAGE_ARTIFACT@@|${ESP_IMAGE_ARTIFACT}|" \
        -e "s|@@SYSTEM_IMAGE_ARTIFACT@@|${SYSTEM_IMAGE_ARTIFACT}|" \
        -e "s|@@UPDATE_BUNDLE_ARTIFACT@@|${UPDATE_BUNDLE_ARTIFACT}|" \
        -e "s|@@MACHINE@@|${MACHINE}|" \
        -e "s|@@QB_CPU_VALUE@@|${QB_CPU_VALUE}|" \
        -e "s|@@QB_MEM_VALUE@@|${QB_MEM_VALUE}|" \
        -e "s|@@QB_SMP@@|${QB_SMP}|" \
        -i ${DEPLOYDIR}/${LG_CONFIG_FILE}
}

addtask deploy after do_fetch before do_build