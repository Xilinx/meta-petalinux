DESCRIPTION = "PetaLinux mraa and upm supported packages"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

MRAA_UPM_PACKAGES = " \
	mraa \
	mraa-dev \
	python3-mraa \
	mraa-utils \
	upm \
	upm-dev \
	python3-upm \
	nodejs \
	nodejs-dev \
	nodejs-npm \
	"

RDEPENDS:${PN} = "${MRAA_UPM_PACKAGES}"
