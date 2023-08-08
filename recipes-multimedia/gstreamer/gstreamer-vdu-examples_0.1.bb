DESCRIPTION = "Demo scripts to run common usecases involving VDU in Versal"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=17e31b2e971eed6471a361c7dc4faa18"

BRANCH  ?= "master"
SRCREV  = "3ad4ad2f03f3b183a9c15ef1ba8c98435ff23dc2"
SRC_URI = "git://github.com/Xilinx/multimedia-notebooks.git;protocol=https;branch=master"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:versal-ai-core = "versal-ai-core"
COMPATIBLE_MACHINE:versal-ai-edge = "versal-ai-edge"

RDEPENDS:${PN} = "gstreamer1.0-omx gstreamer1.0-plugins-bad bash python3-pip alsa-utils"

EXTRA_OEMAKE = 'D=${D} bindir=${bindir} datadir=${datadir}'

do_install() {
	oe_runmake -C ${S}/vdu install_vdu_examples
}

# These libraries shouldn't get installed in world builds unless something
# explicitly depends upon them.

EXCLUDE_FROM_WORLD = "1"

PACKAGE_ARCH:versal = "${SOC_VARIANT_ARCH}"
