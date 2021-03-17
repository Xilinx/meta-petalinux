DESCRIPTION = "SOM related packages"

inherit packagegroup

DEFAULT_FW_PACKAGE_k26 = "kv260-dp"

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
        image-update \
        ldd \
        ntp \
        resize-part \
        tree \
        tzdata \
        xmutil \
	${DEFAULT_FW_PACKAGE} \
	"

RDEPENDS_${PN} = "${SOM_PACKAGES}"
