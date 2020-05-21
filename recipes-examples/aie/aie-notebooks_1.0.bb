DESCRIPTION = "Jupyter notebooks for AI Engine in Versal devices"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=268f2517fdae6d70f4ea4c55c4090aa8"

inherit jupyter-examples

SRC_URI = "file://LICENSE \
           file://README \
           file://aie-matrix-multiplication.ipynb \
           file://pics/data_movement.png \
           file://pics/compilation_flow.png \
           file://pics/runtime_execution.png \
           file://pics/aie_app_data_movement.png \
           file://pics/work_directory.png \
           "
COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_versal = "versal"

RDEPENDS_${PN} = "packagegroup-petalinux-jupyter \
                  aie-matrix-multiplication \
                  "

do_install() {
    install -d ${D}/${JUPYTER_DIR}/aie-notebooks
    install -d ${D}/${JUPYTER_DIR}/aie-notebooks/pics

    install -m 0644 ${S}/README ${D}/${JUPYTER_DIR}/aie-notebooks
    install -m 0755 ${S}/*.ipynb ${D}/${JUPYTER_DIR}/aie-notebooks
    install -m 0755 ${S}/pics/*.png ${D}/${JUPYTER_DIR}/aie-notebooks/pics
}

