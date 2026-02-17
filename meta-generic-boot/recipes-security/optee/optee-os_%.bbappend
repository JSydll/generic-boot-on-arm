SRC_URI:remove:virt-aarch64 = " \
    file://0001-optee-enable-clang-support.patch \
    file://0002-Add-optee-ta-instanceKeepCrashed.patch \
"

OPTEE_BOARD_SPECIFIC_INC = ""
OPTEE_BOARD_SPECIFIC_INC:verdin-imx8mp = "optee_verdin-imx8mp.inc"

require ${OPTEE_BOARD_SPECIFIC_INC}