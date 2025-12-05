# Heavily inspired by https://gitlab.com/Linaro/trustedsubstrate/meta-ts/-/tree/master/meta-trustedsubstrate/recipes-bsp/edk2-firmware
PROVIDES:remove = "virtual/bootloader"
COMPATIBLE_MACHINE = "${MACHINE}"

EDK2_BUILD_RELEASE = "0"
EDK2_PLATFORM      = "MmStandaloneRpmb"
EDK2_PLATFORM_DSC  = "Platform/StandaloneMm/PlatformStandaloneMmPkg/PlatformStandaloneMmRpmb.dsc"
EDK2_BIN_NAME      = "BL32_AP_MM.fd"

do_deploy:append() {
    mv ${DEPLOYDIR}/uefi.bin ${DEPLOYDIR}/edk2-stmm.bin
}