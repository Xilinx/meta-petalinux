SUMMARY = "Host packages for the standalone SDK or external toolchain providing vvas"

inherit packagegroup nativesdk

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

RDEPENDS:${PN} = " \
    nativesdk-protobuf \
    nativesdk-protobuf-c \
    nativesdk-protobuf-compiler \
    nativesdk-protobuf-dev \
"
