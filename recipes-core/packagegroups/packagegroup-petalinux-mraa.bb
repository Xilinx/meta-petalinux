DESCRIPTION = "PetaLinux mraa and upm supported Packages"

LICENSE = "NONE"

inherit packagegroup

MRAA_UPM_PACKAGES = " \
	mraa \
	mraa-dev \
	python-mraa \
	mraa-utils \
	node-mraa \
	upm \
	upm-dev \
	node-upm \
	python-upm \
	nodejs \
	nodejs-dev \
	"

RDEPENDS_${PN} += "${MRAA_UPM_PACKAGES}"
