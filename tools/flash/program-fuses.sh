#!/bin/bash -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_DIR

IMX_FUSE_CONFIG_FILE="$1"

if [[ -z "${IMX_FUSE_CONFIG_FILE}" ]]; then
    echo "Usage: $0 <imx-fuse-config-file>"
    exit 1
fi

echo "Starting recovery mode..."
${SCRIPT_DIR}/run-recovery.sh

echo "Programming fuses according to ${IMX_FUSE_CONFIG_FILE}..."
tail -n +2 "${IMX_FUSE_CONFIG_FILE}" | while IFS= read -r line; do
    cmd_parts=(${line//:/ })
    bank="${cmd_parts[2]}"
    work="${cmd_parts[3]}"
    value="${cmd_parts[4]}"
    ${SCRIPT_DIR}/run-fastboot-cmd.sh "ucmd:'fuse prog -y ${bank} ${work} ${value}'"
done

echo "Done."