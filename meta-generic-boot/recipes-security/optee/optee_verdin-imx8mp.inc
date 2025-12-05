DEPENDS:append = " edk2-firmware"
EDK2_STANDALONE_MM_BIN = "edk2-stmm.bin"

EXTRA_OEMAKE += "CFG_STMM_PATH=../../build/${EDK2_STANDALONE_MM_BIN}"

do_compile:prepend() {
    cp ${DEPLOY_DIR_IMAGE}/${EDK2_STANDALONE_MM_BIN} ${B}
}

