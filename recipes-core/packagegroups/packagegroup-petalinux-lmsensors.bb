DESCRIPTION = "PetaLinux packages that provides tools and drivers for monitoring temperatures, voltage"

inherit packagegroup

LMSENSORS_PACKAGES = " \
	lmsensors-sensors \
	lmsensors-libsensors \
	lmsensors-sensorsdetect \
	"

RDEPENDS:${PN} = "${LMSENSORS_PACKAGES}"
