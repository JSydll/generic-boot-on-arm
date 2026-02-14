#!/bin/bash -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_DIR

readonly UEFI_AUTH_VARS=("PK" "KEK" "db" "dbx")

UEFI_AUTH_BLOBS_DIR="$1"

if [[ -z "${UEFI_AUTH_BLOBS_DIR}" ]]; then
    echo "Usage: $0 <uefi-auth-blobs-dir>"
    exit 1
fi

echo "Starting recovery mode..."
${SCRIPT_DIR}/run-recovery.sh

echo "Deploying UEFI authentication blobs from ${UEFI_AUTH_BLOBS_DIR}..."

for var in "${UEFI_AUTH_VARS[@]}"; do
    if [[ ! -f "${UEFI_AUTH_BLOBS_DIR}/${var}.auth" ]]; then
        echo "Error: Authentication file ${UEFI_AUTH_BLOBS_DIR}/${var}.auth not found."
        exit 1
    fi
done

for var in "${UEFI_AUTH_VARS[@]}"; do
    ${SCRIPT_DIR}/run-fastboot-cmd.sh "download:${UEFI_AUTH_BLOBS_DIR}/${var}.auth"
    ${SCRIPT_DIR}/run-fastboot-cmd.sh "ucmd:'env set -e -nv -bs -rt -at -i 44200000:\$filesize ${var}'"
done

echo "Done."