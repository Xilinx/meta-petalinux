DESCRIPTION = "Jupyter notebooks for openAMP"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=268f2517fdae6d70f4ea4c55c4090aa8"

inherit jupyter-examples
 
SRC_URI = "file://LICENSE \
           file://apu-start-rpu.ipynb \
           file://pics/ampLinuxBMrtos.png \
           file://pics/apu-start-rpu.png "

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"
COMPATIBLE_MACHINE_versal = "versal"

RDEPENDS_${PN} = " packagegroup-petalinux-jupyter \
                   packagegroup-petalinux-openamp"

do_install() {
    install -d ${D}/${JUPYTER_DIR}/openamp-notebooks
    install -d ${D}/${JUPYTER_DIR}/openamp-notebooks/pics

    install -m 0755 ${S}/*.ipynb    ${D}/${JUPYTER_DIR}/openamp-notebooks
    install -m 0755 ${S}/pics/*.png ${D}/${JUPYTER_DIR}/openamp-notebooks/pics
}
