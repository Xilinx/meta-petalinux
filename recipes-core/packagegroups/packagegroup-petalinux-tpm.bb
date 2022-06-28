DESCRIPTION = "TPM related packages"

inherit packagegroup

TPM_PACKAGES = " \
	tpm2-abrmd \
	tpm2-pkcs11 \
	tpm2-tools \
	tpm2-tss \
	tpm2-tss-engine \
	libtpm \
	swtpm \
	libtss2-tcti-device \
	"

RDEPENDS:${PN} = "${TPM_PACKAGES}"
