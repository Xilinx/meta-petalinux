DESCRIPTION = "PetaLinux packages to debug network related issues"

inherit packagegroup

NETWORKING_DEBUG_PACKAGES = " \
	tcpdump \
	wireshark \
	"

RDEPENDS_${PN} = "${NETWORKING_DEBUG_PACKAGES}"
