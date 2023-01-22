require gstreamer-xilinx-1.20.3.inc

SRC_URI:append = " \
    file://0001-libav-Fix-for-APNG-encoder-property-registration.patch \
"

S = "${WORKDIR}/git/subprojects/gst-libav"
