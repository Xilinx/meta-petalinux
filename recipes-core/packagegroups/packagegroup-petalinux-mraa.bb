DESCRIPTION = "PetaLinux mraa and upm supported Packages"

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
	python3-upm \
	nodejs \
	nodejs-dev \
	nodejs-npm \
	"

RDEPENDS_${PN} = "${MRAA_UPM_PACKAGES}"
