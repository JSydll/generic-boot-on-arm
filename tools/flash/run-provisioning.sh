#!/bin/bash -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_DIR
readonly PROVISIONING_CONFIG="provisioning-imx8mp.yml"

echo "WARNING: This will automatically provision the RPMB authentication key!"
echo "Be sure to only run this on a closed device (i.e. after enabling HAB secure boot)!"

read -p "Confirm device is in recovery mode (press Enter to continue)..."

snagrecover -s imx865 -f ${SCRIPT_DIR}/${PROVISIONING_CONFIG}