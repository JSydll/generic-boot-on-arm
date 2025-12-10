# Set the required entrypoint and loadaddress
# These are usually 00008000 for ARM machines
UBOOT_ENTRYPOINT = "0x00008000"
UBOOT_LOADADDRESS = "0x00008000"

# Note that for QEMU does not support authenticated EFI variables, due to missing RPMB emulation.
# For this reason, the secrets must be baked into the binary, which is implemented in meta-arm/recipes-bsp/u-boot/u-boot_%.bbappend.
SRC_URI:append= " \
    file://uefi-insecure-vars.cfg \
"
