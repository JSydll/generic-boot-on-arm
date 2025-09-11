FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# UEFI / secure boot related configuration already pulled in by meta-arm.
SRC_URI:append = " \
    file://overlayfs.cfg \    
"

# Architecture specific kernel configuration
KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"