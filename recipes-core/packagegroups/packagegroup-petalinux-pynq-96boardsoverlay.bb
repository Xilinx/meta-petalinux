DESCRIPTION = "Packages to run PYNQ on Ultra96"

inherit packagegroup

RDEPENDS_${PN} = "  \
    packagegroup-petalinux-jupyter \
    packagegroup-petalinux-pynq \
    sensors96b-overlays-notebooks \
    packagegroup-petalinux-mraa \
    connman \
    connman-client \
    connman-tools \
    ultra96-ap-setup \
    start-jupyter \
"
