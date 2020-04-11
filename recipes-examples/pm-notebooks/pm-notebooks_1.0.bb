DESCRIPTION = "Jupyter notebook examples for Power Management (PM) in Versal devices"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=268f2517fdae6d70f4ea4c55c4090aa8"

inherit jupyter-examples

SRC_URI = "file://LICENSE \
           file://README \
           file://pm-cpufreq.ipynb \
           file://pm-hotplug.ipynb \
           file://pm-clktree.ipynb \
           file://pm-suspend-resume.ipynb \
           file://pm-subsys-restart.ipynb \
           file://images/boot-demo.bif \
           file://images/boot-demo.bin \
           file://pmutil/__init__.py \
           file://pmutil/cpufreq.py \
           file://pmutil/hotplug.py \
           file://pmutil/clktree.py \
           file://pmutil/data/cpu-icon-0-off.png \
           file://pmutil/data/cpu-icon-0-on.png \
           file://pmutil/data/cpu-icon-1-off.png \
           file://pmutil/data/cpu-icon-1-on.png \
           file://pmutil/data/cpu-icon-freq-1.png \
           file://pmutil/data/cpu-icon-freq-2.png \
           file://pmutil/data/cpu-icon-freq-3.png \
           file://pmutil/data/cpu-icon-freq-4.png \
           file://pmutil/data/cpu-icon-freq-def.png \
           "
COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_versal = "versal"

RDEPENDS_${PN} = "packagegroup-petalinux-jupyter \
                  python3-ipywidgets \
                  python3-pydot \
                  "

do_install() {
    install -d ${D}/${JUPYTER_DIR}/pm-notebooks
    install -d ${D}/${JUPYTER_DIR}/pm-notebooks/images
    install -d ${D}/${JUPYTER_DIR}/pm-notebooks/pmutil
    install -d ${D}/${JUPYTER_DIR}/pm-notebooks/pmutil/data

    install -m 0644 ${S}/README ${D}/${JUPYTER_DIR}/pm-notebooks
    install -m 0755 ${S}/*.ipynb ${D}/${JUPYTER_DIR}/pm-notebooks
    install -m 0755 ${S}/images/* ${D}/${JUPYTER_DIR}/pm-notebooks/images
    install -m 0755 ${S}/pmutil/*.py ${D}/${JUPYTER_DIR}/pm-notebooks/pmutil
    install -m 0755 ${S}/pmutil/data/*.png ${D}/${JUPYTER_DIR}/pm-notebooks/pmutil/data
}

