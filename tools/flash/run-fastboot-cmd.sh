#!/bin/bash -e

if [[ -z "${RECOVERY_FASTBOOT_DEV_ID}" ]]; then
    echo "RECOVERY_FASTBOOT_DEV_ID is not set. This script is intended to be run after sourcing the env-init." 
    exit 1
fi

snagflash -P fastboot -p ${RECOVERY_FASTBOOT_DEV_ID} -f "$@"