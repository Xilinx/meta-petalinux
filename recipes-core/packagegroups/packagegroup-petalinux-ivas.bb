DESCRIPTION = "Intelligent Video Analytics SDK (IVAS) packages"

inherit packagegroup

IVAS_PACKAGES = " \
	ivas-accel-libs \
	ivas-gst \
	ivas-utils \
	"

RDEPENDS_${PN} = "${IVAS_PACKAGES}"
