DESCRIPTION = "Required packages for 96boards sensor mezzanine examples"

inherit packagegroup

96BOARD_SENSOR_PACKAGES = " \
	sensor-mezzanine-examples \
	arduino-toolchain \
	avrdude \
	ntp \
	python-requests-oauthlib \
	python-oauthlib \
	python-twitter \
	packagegroup-core-buildessential \
	packagegroup-petalinux-mraa	 \
	python-argparse \
	python-importlib \
	python-pyserial \
	readline \
	libftdi	\
	"

RDEPENDS_${PN} = "${96BOARD_SENSOR_PACKAGES}"
