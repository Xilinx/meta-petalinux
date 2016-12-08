DESCRIPTION = "PetaLinux opencv supported Packages"

LICENSE = "NONE"

inherit packagegroup

OPENCV_PACKAGES = " \
	opencv \
	libopencv-core-dev \
	libopencv-highgui-dev \
	libopencv-imgproc-dev \
	libopencv-objdetect-dev \
	libopencv-ml-dev \
	libopencv-calib3d \
	"

RDEPENDS_${PN}_append_zynq += " \
	${OPENCV_PACKAGES} \
	"

RDEPENDS_${PN}_append_zynqmp += " \
	${OPENCV_PACKAGES} \
	"
