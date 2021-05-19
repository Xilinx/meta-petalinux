DESCRIPTION = "SOM related packages"

BOARDVARIANT_ARCH ??= "${MACHINE_ARCH}"
PACKAGE_ARCH_k26 = "${BOARDVARIANT_ARCH}"

inherit packagegroup

DEFAULT_FW_PACKAGE ?= ""
DEFAULT_FW_PACKAGE_k26 = "kv260-dp"

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
	${DEFAULT_FW_PACKAGE} \
	"

RDEPENDS_${PN} = "${SOM_PACKAGES}"
