TOOLCHAIN_OUTPUTNAME ?= "${SDK_ARCH}-createrepo-nativesdk-standalone-${DISTRO_VERSION}"

require recipes-core/meta/buildtools-tarball.bb

TOOLCHAIN_TARGET_TASK = ""
TOOLCHAIN_HOST_TASK = "nativesdk-sdk-provides-dummy meta-environment-${MACHINE} nativesdk-createrepo-c"

SDK_TITLE = "DNF Repository Indexing"

