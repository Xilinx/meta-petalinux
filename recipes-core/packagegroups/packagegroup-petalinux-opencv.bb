DESCRIPTION = "PetaLinux opencv supported Packages"


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

RDEPENDS_${PN} += "${OPENCV_PACKAGES}"
