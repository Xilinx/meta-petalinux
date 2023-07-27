DESCRIPTION = "Demo scripts to run common usecases involving VCU in ZynqMP"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=17e31b2e971eed6471a361c7dc4faa18"

BRANCH  ?= "master"
SRCREV  = "feefc4ff50080285c9f9c303e572815f70dcf99b"
SRC_URI = "git://gitenterprise.xilinx.com/xilinx-vcu/multimedia-notebooks.git;protocol=https"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp-ev = "zynqmp-ev"
COMPATIBLE_MACHINE:versal-ai-core = "versal-ai-core" 
COMPATIBLE_MACHINE:versal-ai-edge = "versal-ai-edge" 

RDEPENDS:${PN} = "gstreamer1.0-omx gstreamer1.0-plugins-bad bash python3-pip alsa-utils"

do_install() {
    install -d ${D}/${bindir}
    install -d ${D}/${datadir}/applications

    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/4K_AVC_Decode.desktop ${D}/${datadir}/applications
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/4K_HEVC_Decode.desktop ${D}/${datadir}/applications
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/VCU_Examples_ReadMe.desktop ${D}/${datadir}/applications
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/VCU-Examples-ReadMe.txt ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-camera-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-camera-encode-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-camera-encode-file.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-camera-encode-streamout.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-streamin-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-transcode-to-file.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-transcode-to-streamout.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-videotestsrc-hdr-to-file.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu/gstreamer-vcu-examples/vcu-demo-functions.sh ${D}/${bindir}
}

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.

EXCLUDE_FROM_WORLD = "1"

PACKAGE_ARCH:zynqmp = "${SOC_VARIANT_ARCH}"
