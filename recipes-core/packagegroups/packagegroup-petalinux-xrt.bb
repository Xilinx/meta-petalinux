DESCRIPTION = "PetaLinux XRT packages"

inherit packagegroup

PACKAGE_XRT = " \
	zocl \
	xrt \
	opencl-clhpp \
	opencl-headers \
	protobuf \
	"

RDEPENDS_${PN} = "${PACKAGE_XRT}"
