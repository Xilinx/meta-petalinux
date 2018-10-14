DESCRIPTION = "Demo scripts to run common usecases involving VCU in ZynqMP"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "file://vcu-demo-camera-decode-display.sh \
           file://vcu-demo-camera-encode-decode-display.sh \
           file://vcu-demo-camera-encode-file.sh \
           file://vcu-demo-camera-encode-streamout.sh \
           file://vcu-demo-decode-display.sh \
           file://vcu-demo-streamin-decode-display.sh \
           file://vcu-demo-transcode-to-file.sh \
           file://vcu-demo-transcode-to-streamout.sh \
           file://vcu-demo-functions.sh \
           file://4K_AVC_Decode.desktop \
           file://4K_HEVC_Decode.desktop \
           file://VCU_Examples_ReadMe.desktop \
           file://VCU-Examples-ReadMe.txt"

S = "${WORKDIR}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmpev = "zynqmpev"

RDEPENDS_${PN} = "gstreamer1.0-omx gstreamer1.0-plugins-bad bash python3-pip alsa-utils"

do_install() {
    install -d ${D}/${bindir}
    install -d ${D}/${datadir}/applications

    install -m 0755 ${S}/4K_AVC_Decode.desktop ${D}/${datadir}/applications
    install -m 0755 ${S}/4K_HEVC_Decode.desktop ${D}/${datadir}/applications
    install -m 0755 ${S}/VCU_Examples_ReadMe.desktop ${D}/${datadir}/applications
    install -m 0755 ${S}/VCU-Examples-ReadMe.txt ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-camera-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-camera-encode-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-camera-encode-file.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-camera-encode-streamout.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-streamin-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-transcode-to-file.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-transcode-to-streamout.sh ${D}/${bindir}
    install -m 0755 ${S}/vcu-demo-functions.sh ${D}/${bindir}
}

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.

EXCLUDE_FROM_WORLD = "1"

PACKAGE_ARCH_zynqmp = "${SOC_FAMILY}${SOC_VARIANT}"
