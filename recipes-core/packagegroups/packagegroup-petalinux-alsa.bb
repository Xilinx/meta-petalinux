DESCRIPTION = "PetaLinux ASLA supported Packages"
LICENSE = "NONE"

inherit packagegroup

ALSA_PACKAGES = " \
	alsa-lib \
	alsa-plugins \
	alsa-tools \
	alsa-utils \
	alsa-utils-scripts \
	pulseaudio \
	"
RDEPENDS_${PN}_append_zynqmp += " \
        ${ALSA_PACKAGES} \
        "

