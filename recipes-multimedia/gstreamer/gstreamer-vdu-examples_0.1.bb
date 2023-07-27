DESCRIPTION = "Demo scripts to run common usecases involving VDU in Versal"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=17e31b2e971eed6471a361c7dc4faa18"

BRANCH  ?= "master"
SRCREV  = "feefc4ff50080285c9f9c303e572815f70dcf99b"
SRC_URI = "git://gitenterprise.xilinx.com/xilinx-vcu/multimedia-notebooks.git;protocol=https"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:versal-ai-core = "versal-ai-core" 
COMPATIBLE_MACHINE:versal-ai-edge = "versal-ai-edge"

RDEPENDS:${PN} = "gstreamer1.0-omx gstreamer1.0-plugins-bad bash python3-pip alsa-utils"

S  = "${WORKDIR}/git"

do_install() {
    install -d ${D}/${bindir}
    install -d ${D}/${datadir}/applications

    install -m 0755 ${S}/vdu/gstreamer-vdu-examples/vdu-demo-decode-display.sh ${D}/${bindir}
    install -m 0755 ${S}/vdu/gstreamer-vdu-examples/vdu-demo-functions.sh ${D}/${bindir}
}

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.

EXCLUDE_FROM_WORLD = "1"

PACKAGE_ARCH:versal-ai-core = "${SOC_VARIANT_ARCH}"

