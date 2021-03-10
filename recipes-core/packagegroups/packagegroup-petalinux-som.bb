DESCRIPTION = "SOM related packages"

inherit packagegroup

SOM_PACKAGES = " \
        packagegroup-core-full-cmdline \
        packagegroup-core-tools-debug \
        packagegroup-core-ssh-dropbear \
        packagegroup-petalinux-jupyter \
        packagegroup-petalinux-networking-stack \
        packagegroup-petalinux-python-modules \
        packagegroup-petalinux-utils \
        packagegroup-petalinux \
        archconfig \
        fru-print \
        ldd \
        ntp \
        resize-part \
        tpm2-abrmd \
        tpm2-pkcs11 \
        tpm2-tools \
        tpm2-tss-engine \
        tree \
        tzdata \
        xmutil \
	"

RDEPENDS_${PN} = "${SOM_PACKAGES}"
