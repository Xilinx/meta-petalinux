DESCRIPTION = "PetaLinux opencv supported packages"

inherit packagegroup

OPENCV_PACKAGES = " \
	opencv \
	libopencv-core \
	libopencv-highgui \
	libopencv-imgproc \
	libopencv-objdetect \
	libopencv-ml \
	libopencv-calib3d \
	libopencv-ccalib \
	"

RDEPENDS_${PN} = "${OPENCV_PACKAGES}"
