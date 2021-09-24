DESCRIPTION = "Jupyter notebook examples for Platform Management (PM) in Versal devices"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../../LICENSE;md5=268f2517fdae6d70f4ea4c55c4090aa8"

inherit jupyter-examples

SRC_URI = "git://gitenterprise.xilinx.com/Platform-Management/oob-demos.git;branch=master;protocol=https \
           file://LICENSE \
           "

SRCREV = "1a19aea2d47e681f3b85c4a74e8cbfc4c30acfa4"

S = "${WORKDIR}/git/pm-notebooks"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_versal = "versal"

RDEPENDS_${PN} = "packagegroup-petalinux-jupyter \
                  python3-ipywidgets \
                  python3-pydot \
                  "

do_install() {
    install -d ${D}/${JUPYTER_DIR}/pm-notebooks
    install -d ${D}/${JUPYTER_DIR}/pm-notebooks/pmutil
    install -d ${D}/${JUPYTER_DIR}/pm-notebooks/pmutil/data

    install -m 0644 ${S}/README ${D}/${JUPYTER_DIR}/pm-notebooks
    install -m 0755 ${S}/*.ipynb ${D}/${JUPYTER_DIR}/pm-notebooks
    install -m 0755 ${S}/pmutil/*.py ${D}/${JUPYTER_DIR}/pm-notebooks/pmutil
    install -m 0755 ${S}/pmutil/data/*.png ${D}/${JUPYTER_DIR}/pm-notebooks/pmutil/data
}

