# UEFI / secure boot related configuration already pulled in by meta-arm.

# Architecture specific kernel configuration
KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"