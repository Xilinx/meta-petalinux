DESCRIPTION = "SOM related packages"

inherit packagegroup

SOM_PACKAGES = " \
        archconfig \
        fru-print \
        ntp \
        tpm2-abrmd \
        tpm2-pkcs11 \
        tpm2-tools \
        tpm2-tss-engine \
        xmutil \
	"

RDEPENDS_${PN} = "${SOM_PACKAGES}"
