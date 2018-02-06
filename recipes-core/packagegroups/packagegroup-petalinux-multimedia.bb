DESCRIPTION = "PetaLinux packages to enhance out of box multimedia experience"

inherit packagegroup

MULTIMEDIA_PACKAGES = " \
	packagegroup-petalinux-gstreamer \
	packagegroup-petalinux-matchbox \
	packagegroup-petalinux-x11 \
	packagegroup-petalinux-display-debug \
	packagegroup-petalinux-qt \
	ffmpeg \
	"

RDEPENDS_${PN} = "${MULTIMEDIA_PACKAGES}"
