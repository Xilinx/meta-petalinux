TOOLCHAIN_OUTPUTNAME ?= "${SDK_ARCH}-createrepo-nativesdk-standalone-${DISTRO_VERSION}"

require recipes-core/meta/buildtools-tarball.bb

PLNX_ADD_VAI_SDK = ""

TOOLCHAIN_TARGET_TASK = ""
TOOLCHAIN_HOST_TASK = "nativesdk-sdk-provides-dummy meta-environment-${MACHINE} nativesdk-createrepo-c"

SDK_TITLE = "DNF Repository Indexing"

