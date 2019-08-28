DESCRIPTION = "PetaLinux XRT packages"

inherit packagegroup

PACKAGE_XRT = " \
	zocl \
	xrt \
	"

RDEPENDS_${PN} = "${PACKAGE_XRT}"
