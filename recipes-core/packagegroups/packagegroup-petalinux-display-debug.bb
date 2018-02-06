DESCRIPTION = "PetaLinux packages to test and debug display ports"

inherit packagegroup

DISPLAY_DEBUG_PACKAGES = " \
	libdrm \
	libdrm-tests \
	libdrm-kms \
	"
RDEPENDS_${PN} = "${DISPLAY_DEBUG_PACKAGES}"
