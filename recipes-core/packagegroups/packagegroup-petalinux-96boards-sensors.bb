DESCRIPTION = "Required packages for 96boards sensor mezzanine examples"

inherit packagegroup

96BOARD_SENSOR_PACKAGES = " \
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

96BOARD_SENSOR_PACKAGES_append_ultra96-zynqmp = " sensor-mezzanine-examples"

RDEPENDS_${PN} = "${96BOARD_SENSOR_PACKAGES}"
