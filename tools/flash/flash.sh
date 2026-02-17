#!/bin/bash -e
# Helper script to flash a complete system image on the Toradex Verdin iMX8MP board.
#
# Usage: ./flash.sh <boot-container-image-path> <system-image-path>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_DIR

readonly FLASHING_SCRIPT="flash-system.fbscr"
readonly FLASHING_BOOTCONTAINER_IMAGE_FILE="flash.bin"
readonly FLASHING_SYSTEM_IMAGE_FILE="system-image.wic"

if [[ -z "${RECOVERY_FASTBOOT_DEV_ID}" ]]; then
    echo "RECOVERY_FASTBOOT_DEV_ID is not set. This script is intended to be run after sourcing the env-init." 
    exit 1
fi

ARTIFACTS_DIR="$1"
BOOTCONTAINER_IMAGE_NAME="$2"
SYSTEM_IMAGE_NAME="$3"

if [[ -z "${ARTIFACTS_DIR}" || -z "${BOOTCONTAINER_IMAGE_NAME}" || -z "${SYSTEM_IMAGE_NAME}" ]]; then
    echo "Usage: $0 <artifacts-dir> <boot-container-image-name> <system-image-name>"
    exit 1
fi

readonly BOOTCONTAINER_IMAGE_PATH="${ARTIFACTS_DIR}/${BOOTCONTAINER_IMAGE_NAME}"
readonly SYSTEM_IMAGE_PATH="${ARTIFACTS_DIR}/${SYSTEM_IMAGE_NAME}"
echo "Preparing to flash ${BOOTCONTAINER_IMAGE_PATH} and ${SYSTEM_IMAGE_PATH}..."

pushd ${SCRIPT_DIR}
# Cleanup on exit
trap 'rm -f ${FLASHING_BOOTCONTAINER_IMAGE_FILE} ${FLASHING_SYSTEM_IMAGE_FILE} ${FLASHING_SYSTEM_IMAGE_FILE}.bmap && popd' EXIT TERM INT

echo "Entering recovery mode..."
./run-recovery.sh

echo "Waiting for device to appear in fastboot mode..."
while ! lsusb | grep -q "ID ${RECOVERY_FASTBOOT_DEV_ID}"; do
    sleep 1
done

echo "Creating temporary symlinks to artifacts..."
ln -snf "${BOOTCONTAINER_IMAGE_PATH}" ${FLASHING_BOOTCONTAINER_IMAGE_FILE}
ln -snf "${SYSTEM_IMAGE_PATH}" ${FLASHING_SYSTEM_IMAGE_FILE}
if [[ -f "${SYSTEM_IMAGE_PATH}.bmap" ]]; then
    ln -snf "${SYSTEM_IMAGE_PATH}.bmap" ${FLASHING_SYSTEM_IMAGE_FILE}.bmap
fi

echo "Flashing..."
snagflash -P fastboot-uboot -p ${RECOVERY_FASTBOOT_DEV_ID} -I ${FLASHING_SCRIPT}

echo "Done. Perform manual power cycle to boot into the new system."