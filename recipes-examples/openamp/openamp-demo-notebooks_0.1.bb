DESCRIPTION = "Jupyter notebooks for openAMP"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=268f2517fdae6d70f4ea4c55c4090aa8"
 
SRC_URI = "file://LICENSE \
           file://apu-start-rpu.ipynb \
           file://pics/ampLinuxBMrtos.png \
           file://pics/apu-start-rpu.png "

S = "${WORKDIR}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"
COMPATIBLE_MACHINE_versal = "versal"

RDEPENDS_${PN} = " packagegroup-petalinux-jupyter \
                   packagegroup-petalinux-openamp"

do_install() {
    install -d ${D}/${datadir}/openamp-notebooks
    install -d ${D}/${datadir}/openamp-notebooks/pics

    install -m 0755 ${S}/*.ipynb    ${D}/${datadir}/openamp-notebooks
    install -m 0755 ${S}/pics/*.png ${D}/${datadir}/openamp-notebooks/pics
}

FILES_${PN} += "${datadir}"

# These notebooks shouldn't in world builds unless
# something explicitly depends upon them.
EXCLUDE_FROM_WORLD = "1"

PACKAGE_ARCH = "${SOC_FAMILY}"
