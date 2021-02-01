DESCRIPTION = "SOM related packages"

inherit packagegroup

SOM_PACKAGES = " \
        ntp \
        tpm2-tools \
        tpm2-abrmd \
        tpm2-tss-engine \
        tpm2-pkcs11 \
	"

RDEPENDS_${PN} = "${SOM_PACKAGES}"
