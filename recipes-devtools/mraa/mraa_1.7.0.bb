require mraa.inc

SRC_URI = " \
	git://github.com/intel-iot-devkit/mraa.git;protocol=git;tag=v${PV} \
	file://0001-Add-missing-libmraa-package-list.patch \
	file://0001-Add-support-for-zcu100.patch"

