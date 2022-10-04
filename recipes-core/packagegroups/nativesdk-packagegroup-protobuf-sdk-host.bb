SUMMARY = "Host packages for the standalone SDK or external toolchain providing protobuf"

# It just can't be all, which packagegroup will default to
PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup nativesdk

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

RDEPENDS:${PN} = " \
    nativesdk-protobuf \
    nativesdk-protobuf-c \
    nativesdk-protobuf-compiler \
    nativesdk-protobuf-dev \
"
