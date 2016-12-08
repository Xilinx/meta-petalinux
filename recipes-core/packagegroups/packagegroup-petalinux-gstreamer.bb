DESCRIPTION = "PetaLinux GSTREAMER supported Packages"
LICENSE = "NONE"

inherit packagegroup

GSTREAMER_PACKAGES = " \
	gstreamer1.0 \
	gstreamer1.0-meta-base \
	gstreamer1.0-plugins-base \
	gstreamer1.0-plugins-good \
	gstreamer1.0-plugins-bad \
	gstreamer1.0-rtsp-server \
	"
RDEPENDS_${PN}_append_zynqmp += " \
        ${GSTREAMER_PACKAGES} \
        "
