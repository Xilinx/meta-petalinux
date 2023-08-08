DESCRIPTION = "Jupyter notebook examples for VDU in Versal"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=17e31b2e971eed6471a361c7dc4faa18"

inherit jupyter-examples

BRANCH  ?= "master"
SRCREV  = "3ad4ad2f03f3b183a9c15ef1ba8c98435ff23dc2"
SRC_URI = "git://github.com/Xilinx/multimedia-notebooks.git;protocol=https;branch=master"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:versal-ai-core = "versal-ai-core"
COMPATIBLE_MACHINE:versal-ai-edge = "versal-ai-edge"

RDEPENDS:${PN} = "packagegroup-petalinux-jupyter packagegroup-petalinux-gstreamer gstreamer-vdu-examples start-jupyter"

EXTRA_OEMAKE = 'D=${D} JUPYTER_DIR=${JUPYTER_DIR}'

do_install() {
	oe_runmake -C ${S}/vdu install_vdu_notebooks
}

PACKAGE_ARCH:versal = "${SOC_VARIANT_ARCH}"
