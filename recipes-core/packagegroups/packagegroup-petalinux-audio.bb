DESCRIPTION = "PetaLinux ASLA supported packages"

inherit packagegroup

ALSA_PACKAGES = " \
	libasound \
	alsa-plugins \
	alsa-tools \
	alsa-utils \
	alsa-utils-scripts \
	pulseaudio \
	sox \
	"
RDEPENDS_${PN} = "${ALSA_PACKAGES}"
