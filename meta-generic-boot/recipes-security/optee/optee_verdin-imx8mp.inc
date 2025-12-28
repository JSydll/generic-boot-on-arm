
EXTRA_OEMAKE += "\
    CFG_STMM_PATH=../../build/${OPTEE_VARSTORE_SUPPLICANT_BIN} \
"

# Make the varstore supplicant available for including it in the build
do_compile:prepend() {
    cp ${DEPLOY_DIR_IMAGE}/${OPTEE_VARSTORE_SUPPLICANT_BIN} ${B}
}

do_compile[depends] += "${OPTEE_VARSTORE_SUPPLICANT}:do_deploy"

