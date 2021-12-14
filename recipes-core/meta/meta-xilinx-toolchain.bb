SUMMARY = "Meta package for building a Xilinx prebuilt installable toolchain"
LICENSE = "MIT"

inherit populate_sdk

COMPATIBLE_HOST = "${HOST_SYS}"

# This is a bare minimum toolchain, so limit to only the basic host
# dependencies
HOST_DEPENDS = " \
  nativesdk-sdk-provides-dummy \
"

PLNX_ADD_VAI_SDK = ""

TOOLCHAIN_HOST_TASK = "${HOST_DEPENDS} packagegroup-cross-canadian-${MACHINE}"
TOOLCHAIN_TARGET_TASK:xilinx-standalone = "${@multilib_pkg_extend(d, 'packagegroup-newlib-standalone-sdk-target')}"
