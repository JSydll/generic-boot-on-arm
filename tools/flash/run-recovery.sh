#!/bin/bash -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_DIR
readonly RECOVERY_CONFIG="recovery-imx8mp.yml"

read -p "Confirm device is in recovery mode (press Enter to continue)..."

snagrecover -s imx865 -f ${SCRIPT_DIR}/${RECOVERY_CONFIG}