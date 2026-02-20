# Extend the basic OP-TEE configuration provided by meta-toradex-security,
# which is enabled by TDX_OPTEE_ENABLE.
# To avoid accidentally fusing the auth key during development / on an open device,
# we use a custom variable to control this part of the behavior.
EXTRA_OEMAKE += "\
    CFG_STMM_PATH=../../build/${OPTEE_VARSTORE_SUPPLICANT_BIN} \
    ${@ bb.utils.contains('OPTEE_RPMB_WRITE_KEY', '1', 'CFG_RPMB_WRITE_KEY=y CFG_RPMB_RESET_FAT=y', '', d)} \
"

# Make the varstore supplicant available for including it in the build
do_compile:prepend() {
    cp ${DEPLOY_DIR_IMAGE}/${OPTEE_VARSTORE_SUPPLICANT_BIN} ${B}
}

do_compile[depends] += "${OPTEE_VARSTORE_SUPPLICANT}:do_deploy"
