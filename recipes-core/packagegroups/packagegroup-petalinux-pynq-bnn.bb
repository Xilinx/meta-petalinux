DESCRIPTION = "Packages to run bnn examples on Ultra96"

inherit packagegroup

RDEPENDS_${PN} = "  \
    packagegroup-petalinux-gstreamer \
    yavta \
    packagegroup-petalinux-opencv \
    python3-modules \
    pynq-ultra96-bnn-notebooks \
    start-jupyter \
    packagegroup-petalinux-pynq \
"
