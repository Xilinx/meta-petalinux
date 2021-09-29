DESCRIPTION = "Intelligent Video Analytics SDK (IVAS) packages"

inherit packagegroup

IVAS_PACKAGES = " \
	ivas-accel-libs \
	ivas-gst \
	ivas-utils \
	"

RDEPENDS:${PN} = "${IVAS_PACKAGES}"
