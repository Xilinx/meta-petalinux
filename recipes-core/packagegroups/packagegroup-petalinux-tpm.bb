DESCRIPTION = "TPM related packages"

inherit packagegroup

TPM_PACKAGES = " \
	tpm2-abrmd \
	tpm2-pkcs11 \
	tpm2-tools \
	tpm2-tss \
	tpm2-tss-engine \
	"

RDEPENDS_${PN} = "${TPM_PACKAGES}"

TPM_PACKAGES_DEV = " \
	tpm2-abrmd-dev \
	tpm2-pkcs11-dev \
	tpm2-tools-dev \
	tpm2-tss-engine-dev \
	"

RDEPENDS_${PN}-dev = "${TPM_PACKAGES_DEV}"
