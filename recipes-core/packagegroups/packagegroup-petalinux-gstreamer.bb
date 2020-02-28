DESCRIPTION = "PetaLinux GSTREAMER supported packages"

inherit packagegroup

GSTREAMER_PACKAGES = " \
	gstreamer1.0 \
	gstreamer1.0-meta-base \
	gstreamer1.0-plugins-base \
	gstreamer1.0-plugins-good \
	gstreamer1.0-plugins-bad \
	gstreamer1.0-rtsp-server \
	gst-shark \
	gstd \
	gst-perf \
	gst-interpipes \
	"
GSTREAMER_PACKAGES_append_zynqmp = " gstreamer1.0-omx"

RDEPENDS_${PN} = "${GSTREAMER_PACKAGES}"
