DESCRIPTION = "Required packages for 96boards sensor mezzanine examples"

inherit packagegroup

96BOARD_SENSOR_PACKAGES = " \
	avrdude \
	ntp \
	packagegroup-core-buildessential \
	packagegroup-petalinux-mraa	 \
	python-argparse \
	python3-pyserial \
	readline \
	libftdi	\
	"

96BOARD_SENSOR_PACKAGES_append_ultra96-zynqmp = " \
	sensor-mezzanine-examples \
	arduino-toolchain \
	python3-oauthlib \
	python3-requests-oauthlib \
	python3-twitter \
	"

RDEPENDS_${PN} = "${96BOARD_SENSOR_PACKAGES}"
