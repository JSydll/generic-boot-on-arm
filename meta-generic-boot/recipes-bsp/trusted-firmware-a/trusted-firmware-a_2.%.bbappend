# Configuration of the TF-A extended firmware package
#

TFA_BOARD_SPECIFIC_INC = ""
TFA_BOARD_SPECIFIC_INC:virt-aarch64 = "trusted-firmware-a_virt-aarch64.inc"

require ${TFA_BOARD_SPECIFIC_INC}