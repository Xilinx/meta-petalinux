DESCRIPTION = "PetaLinux self hosted tools packages"

inherit packagegroup

SELF_HOSTED_PACKAGES = " \
	packagegroup-self-hosted \
	whetstone \
	vim \
	"

RDEPENDS_${PN} = "${SELF_HOSTED_PACKAGES}"
