DESCRIPTION = "SOM related packages"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:k26 = "${MACHINE}"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

SOM_PACKAGES = " \
        accelize-repo \
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
        image-update \
        ldd \
        ntp \
        resize-part \
        tree \
        tzdata \
        xmutil \
	som-dashboard \
	"

RDEPENDS:${PN} = "${SOM_PACKAGES}"
