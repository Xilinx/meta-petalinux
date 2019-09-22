DESCRIPTION = "Packages to create PYNQ rpm "

inherit packagegroup

RDEPENDS_${PN} = "  \
    python3-pynq \
    python3-pandas \
    packagegroup-petalinux-jupyter \
    pynq-overlay \
    start-jupyter \
"
