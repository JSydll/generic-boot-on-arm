# -------------------
# Provides labgrid test environment configurations
# -------------------

SUMMARY = "Deploys machine specific labgrid environment configurations suitable for testing our product."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit deploy nopackages allarch

ALLOW_EMPTY:${PN} = "1"

SRC_URI = " \
    file://lg-env-config.yml \
"

S = "${UNPACKDIR}"

LG_CONFIG_FILE = "lg-env-config-${MACHINE}-${PV}-${PR}.yml"
# Our test setup expects artifacts to be published to a generic mount point
LG_ARTIFACT_MOUNTPOINT = "/artifacts"

# Artifact nomenclature
FIRMWARE_ARTIFACT = "flash.bin"
SYSTEM_IMAGE_ARTIFACT = "system-image.wic.qcow2"
UPDATE_BUNDLE_ARTIFACT = "secure-update-bundle-${MACHINE}.raucb"

do_deploy() {
    install -d ${DEPLOYDIR}

    bbdebug 2 "Providing labgrid environment configuration for tests..."
    install -m 0644 ${S}/lg-env-config.yml ${DEPLOYDIR}/${LG_CONFIG_FILE}
    cd ${DEPLOYDIR}
    rm -f lg-env-config-${MACHINE}.yml
    ln -sf ${LG_CONFIG_FILE} lg-env-config-${MACHINE}.yml
}

addtask deploy after do_fetch before do_build