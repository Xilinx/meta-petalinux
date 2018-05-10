DESCRIPTION = "Required packages for 96boards sensor mezzanine examples"

inherit packagegroup

96BOARD_SENSOR_PACKAGES = " \
	avrdude \
	ntp \
	packagegroup-core-buildessential \
	packagegroup-petalinux-mraa	 \
	python-argparse \
	python-importlib \
	python-pyserial \
	readline \
	libftdi	\
	"

96BOARD_SENSOR_PACKAGES_append_ultra96-zynqmp = " \
	sensor-mezzanine-examples \
	arduino-toolchain \
	python-oauthlib \
	python-requests-oauthlib \
	python-twitter \
	"

RDEPENDS_${PN} = "${96BOARD_SENSOR_PACKAGES}"
