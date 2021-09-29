DESCRIPTION = "Packages to run bnn examples on Ultra96"

inherit packagegroup

RDEPENDS:${PN} = "  \
    pynq-ultra96-helloworld-notebooks \
    packagegroup-petalinux-pynq \
"
