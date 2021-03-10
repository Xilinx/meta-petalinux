DESCRIPTION = "SOM related packages"

inherit packagegroup

SOM_PACKAGES = " \
        packagegroup-core-full-cmdline \
        packagegroup-core-tools-debug \
        packagegroup-core-ssh-dropbear \
        packagegroup-petalinux-jupyter \
        packagegroup-petalinux-networking-stack \
        packagegroup-petalinux-python-modules \
        packagegroup-petalinux-tpm \
        packagegroup-petalinux-utils \
        packagegroup-petalinux \
        archconfig \
        fru-print \
        ldd \
        ntp \
        resize-part \
        tree \
        tzdata \
        xmutil \
	"

RDEPENDS_${PN} = "${SOM_PACKAGES}"
