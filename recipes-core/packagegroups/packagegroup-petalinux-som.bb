DESCRIPTION = "SOM related packages"

PACKAGE_ARCH:k26 = "k26"

inherit packagegroup

DEFAULT_FW_PACKAGE ?= ""
DEFAULT_FW_PACKAGE:k26 = "kv260-dp"

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
	${DEFAULT_FW_PACKAGE} \
	"

RDEPENDS:${PN} = "${SOM_PACKAGES}"
