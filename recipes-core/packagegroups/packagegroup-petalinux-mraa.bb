DESCRIPTION = "PetaLinux mraa and upm supported packages"

inherit packagegroup

MRAA_UPM_PACKAGES = " \
	mraa \
	mraa-dev \
	python3-mraa \
	mraa-utils \
	node-mraa \
	upm \
	upm-dev \
	node-upm \
	python-upm \
	nodejs \
	nodejs-dev \
	nodejs-npm \
	"

RDEPENDS_${PN} = "${MRAA_UPM_PACKAGES}"
