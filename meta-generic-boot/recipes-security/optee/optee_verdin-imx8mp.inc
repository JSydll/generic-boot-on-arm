# RPMB configuration provided by meta-toradex-security
EXTRA_OEMAKE += "\
    CFG_STMM_PATH=../../build/${OPTEE_VARSTORE_SUPPLICANT_BIN} \
"
# Note: The i.MX Linux User's Guide also lists the following config options
# found to be not required in the given use case:
#   CFG_ARM64_core=y
#   CFG_IMX_SNVS=n
#   CFG_NXP_CAAM=n
#   CFG_CORE_DYN_SHM=y
#   CFG_SCTLR_ALIGNMENT_CHECK=n
#   CFG_CORE_HEAP_SIZE=2097152
#   CFG_TEE_RAM_VA_SIZE=4194304
#   CFG_PREALLOC_RPC_CACHE=n
#   CFG_REE_FS=n

# Make the varstore supplicant available for including it in the build
do_compile:prepend() {
    cp ${DEPLOY_DIR_IMAGE}/${OPTEE_VARSTORE_SUPPLICANT_BIN} ${B}
}

do_compile[depends] += "${OPTEE_VARSTORE_SUPPLICANT}:do_deploy"

