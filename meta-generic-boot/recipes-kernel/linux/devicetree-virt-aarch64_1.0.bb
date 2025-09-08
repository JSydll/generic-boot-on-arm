# ---
# Out-of-tree device tree for the virt-aarch64 machine.
#
# As we don't boot the kernel directly from QEMU (instead u-boot does)
# and more control of the DT may be useful, this package provides the DT
# as dumped by QEMU (using the '-machine dumpdtb=<name>.dtb' option).

SUMMARY = "Provides an out-of-tree devicetree for the virt-aarch64 machine."

inherit devicetree

SRC_URI = "file://virt-aarch64.dts"

COMPATIBLE_MACHINE = "^(qemuarm64|virt-aarch64)$"
