FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# Upstream u-boot can directly sign the boot container parts using binman and the cst wrapper it has.
# However, the binary and secrets to be used for signing need to be provided.
EXTRA_OEMAKE += "\
    BINMAN_TOOLPATHS='${IMX_CST_TOOL_PATH}' \
    CSF_KEY=${IMX_HAB_CERTS_DIR}/CSF${IMX_HAB_CST_SRK_INDEX}_1_${IMX_HAB_CST_DIG_ALGO}_${IMX_HAB_CST_KEY_SIZE}_65537_v3_usr_crt.pem \
    IMG_KEY=${IMX_HAB_CERTS_DIR}/IMG${IMX_HAB_CST_SRK_INDEX}_1_${IMX_HAB_CST_DIG_ALGO}_${IMX_HAB_CST_KEY_SIZE}_65537_v3_usr_crt.pem \
    SRK_TABLE=${IMX_HAB_CERTS_DIR}/SRK_1_2_3_4_table.bin \
"

SRC_URI:append = " \
    file://bootflow.cfg \
    file://squashfs.cfg \
    file://u-boot-hab.cfg \
    file://uefi-secureboot.cfg \
    file://uefi-authenticated-vars.cfg \
    file://uefi-secureboot-bootslots.cfg \
"
# TODO: Enforce secure boot by adding uefi-secureboot-enable.cfg

# Account for the dependencies for building the boot container
do_compile[depends] += " \
    imx-atf:do_deploy \
    optee-os:do_deploy \
"