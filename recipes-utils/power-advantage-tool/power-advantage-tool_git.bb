#
# This file is the power-advantage-tool recipe.
#

SUMMARY = "Power Advantage Tool"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit jupyter-examples python3-dir

SRC_URI = "git://gitenterprise.xilinx.com/PowerAdvantageTool/jupyter-pat.git;protocol=https;nobranch=1"

PV = "2.2.0+git${SRCPV}"
SRCREV = "51878b8d93cb91e26af67b04d46635b212ca93b9"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_vck-sc-zynqmp = "vck-sc-zynqmp"

RDEPENDS_${PN} = "packagegroup-petalinux-jupyter \
                  python3-ipywidgets \
                  python3-pydot \
                  "
do_install() {
    install -d ${D}/${JUPYTER_DIR}/power-advantage-tool
    install -d ${D}/${JUPYTER_DIR}/power-advantage-tool/img
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}/poweradvantage

    install -m 0755 ${S}/*.ipynb ${D}/${JUPYTER_DIR}/power-advantage-tool
    install -m 0755 ${S}/img/* ${D}/${JUPYTER_DIR}/power-advantage-tool/img
    install -m 0755 ${S}/poweradvantage/* ${D}${PYTHON_SITEPACKAGES_DIR}/poweradvantage
}

FILES_${PN} += "${PYTHON_SITEPACKAGES_DIR}/poweradvantage/* ${JUPYTER_DIR}/*"
