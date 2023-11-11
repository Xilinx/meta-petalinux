DESCRIPTION = "Required packages for 96boards sensor mezzanine examples"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

96BOARD_SENSOR_PACKAGES = " \
	avrdude \
	ntp \
	packagegroup-core-buildessential \
	packagegroup-petalinux-mraa	 \
	python3-pyserial \
	readline \
	libftdi	\
	"

96BOARD_SENSOR_PACKAGES:append:ultra96-zynqmp = " \
	sensor-mezzanine-examples \
	arduino-toolchain \
	python3-oauthlib \
	python3-requests-oauthlib \
	python3-twitter \
	"

RDEPENDS:${PN} = "${96BOARD_SENSOR_PACKAGES}"
