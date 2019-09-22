DESCRIPTION = "Packages to run bnn examples on Ultra96"

inherit packagegroup

RDEPENDS_${PN} = "  \
    pynq-ultra96-helloworld-notebooks \
    packagegroup-petalinux-pynq \
"
