# For StandaloneMM integration, we need at least lf-6.12.49-2.2.0 in downstream OP-TEE,
# as only this contains the support for FF-A v1.2 features.
#
# See upstream commit aa6d7fc for details.
SRCBRANCH = "lf-6.12.49_2.2.0"
SRCREV = "b3883a773a9d15ec6439f9229e48f540c37e0d00"

SRC_URI:remove = " \
    file://0007-allow-setting-sysroot-for-clang.patch \
"