DESCRIPTION = "PetaLinux packages to test and debug display ports"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

DISPLAY_DEBUG_PACKAGES = " \
	libdrm \
	libdrm-tests \
	"
RDEPENDS:${PN} = "${DISPLAY_DEBUG_PACKAGES}"
