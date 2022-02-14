DESCRIPTION = "TSN related packages"

inherit packagegroup

TSN_PACKAGES = " \
	openavb \
	linuxptp \
	lldpd \
	misc-utils \
	"

RDEPENDS:${PN} = "${TSN_PACKAGES}"
