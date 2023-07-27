DESCRIPTION = "Jupyter notebook examples for VCU in ZynqMP-EV devices"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=17e31b2e971eed6471a361c7dc4faa18"
inherit jupyter-examples

BRANCH  ?= "master"
SRCREV  = "feefc4ff50080285c9f9c303e572815f70dcf99b"
SRC_URI = "git://gitenterprise.xilinx.com/xilinx-vcu/multimedia-notebooks.git;protocol=https"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp-ev = "zynqmp-ev"
COMPATIBLE_MACHINE:versal-ai-core = "versal-ai-core"
COMPATIBLE_MACHINE:versal-ai-edge = "versal-ai-edge"

RDEPENDS:${PN} = "packagegroup-petalinux-jupyter packagegroup-petalinux-gstreamer gstreamer-vcu-examples start-jupyter"

S  = "${WORKDIR}/git"

do_install() {
    install -d ${D}/${JUPYTER_DIR}/vcu-notebooks
    install -d ${D}/${JUPYTER_DIR}/vcu-notebooks/pictures

    install -m 0755 ${S}/vcu/gstreamer-vcu-notebooks/pictures/*.png ${D}/${JUPYTER_DIR}/vcu-notebooks/pictures
    install -m 0755 ${S}/vcu/gstreamer-vcu-notebooks/common.py ${D}/${JUPYTER_DIR}/vcu-notebooks/common.py
    install -m 0755 ${S}/vcu/gstreamer-vcu-notebooks/*.ipynb ${D}/${JUPYTER_DIR}/vcu-notebooks

}

PACKAGE_ARCH:zynqmp = "${SOC_VARIANT_ARCH}"
