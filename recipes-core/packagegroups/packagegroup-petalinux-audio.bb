DESCRIPTION = "PetaLinux ASLA supported Packages"

inherit packagegroup

ALSA_PACKAGES = " \
	alsa-lib \
	alsa-plugins \
	alsa-tools \
	alsa-utils \
	alsa-utils-scripts \
	pulseaudio \
	sox \
	"
RDEPENDS_${PN} = "${ALSA_PACKAGES}"
