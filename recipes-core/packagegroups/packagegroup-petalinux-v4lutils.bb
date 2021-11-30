DESCRIPTION = "PetaLinux packages to handle multimedia data"

inherit packagegroup

V4LUTILS_PACKAGES = " \
	v4l-utils \
	yavta \
	"

RDEPENDS:${PN} = "${V4LUTILS_PACKAGES}"
