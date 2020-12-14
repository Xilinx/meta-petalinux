SUMMARY = "Xilinx sensors96b overlays"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

inherit xilinx-pynq python3-dir

RDEPENDS_${PN} += "\
    python3-pynq \
    python3-jupyter \
    packagegroup-petalinux-96boards-sensors \
"

SRC_URI = "git://github.com/Avnet/Ultra96-PYNQ.git;branch=image_v2.4;protocol=https \
"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_ultra96 = "${MACHINE}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRCREV = "bc6675a8c492f17c12b6acdc477343b874a1f217"

S = "${WORKDIR}/git"

FILES_${PN}-notebooks += " \
    ${PYTHON_SITEPACKAGES_DIR}/pynq/overlays/sensors96b/ \
"

do_install () {
   PYNQ_JUPYTER_NOTEBOOKS="${D}${PYNQ_NOTEBOOK_DIR}"
   install -d ${PYNQ_JUPYTER_NOTEBOOKS}/sensors96b
   install -d ${D}${PYTHON_SITEPACKAGES_DIR}/pynq/overlays/sensors96b

   cp -r ${S}/${BOARD_NAME}/sensors96b/notebooks/*  ${PYNQ_JUPYTER_NOTEBOOKS}/sensors96b
   cp -r ${S}/${BOARD_NAME}/sensors96b/* ${D}${PYTHON_SITEPACKAGES_DIR}/pynq/overlays/sensors96b
}

PACKAGE_ARCH_ultra96 = "${BOARD_ARCH}"
