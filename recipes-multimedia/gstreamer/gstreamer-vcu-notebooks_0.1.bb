DESCRIPTION = "Jupyter notebook examples for VCU in ZynqMP-EV devices"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../../LICENSE.md;md5=17e31b2e971eed6471a361c7dc4faa18"

inherit jupyter-examples

BRANCH  ?= "master"
SRCREV  = "3ad4ad2f03f3b183a9c15ef1ba8c98435ff23dc2"
SRC_URI = "git://github.com/Xilinx/multimedia-notebooks.git;protocol=https;branch=master"

S  = "${WORKDIR}/git/vcu/gstreamer-vcu-notebooks"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp-ev = "zynqmp-ev"

RDEPENDS:${PN} = "packagegroup-petalinux-jupyter packagegroup-petalinux-gstreamer gstreamer-vcu-examples start-jupyter"

do_install() {
    install -d ${D}/${JUPYTER_DIR}/vcu-notebooks
    install -d ${D}/${JUPYTER_DIR}/vcu-notebooks/pictures

    install -m 0755 ${S}/pictures/*.png ${D}/${JUPYTER_DIR}/vcu-notebooks/pictures
    install -m 0755 ${S}/common.py ${D}/${JUPYTER_DIR}/vcu-notebooks/common.py
    install -m 0755 ${S}/*.ipynb ${D}/${JUPYTER_DIR}/vcu-notebooks

}

PACKAGE_ARCH:zynqmp = "${SOC_VARIANT_ARCH}"
