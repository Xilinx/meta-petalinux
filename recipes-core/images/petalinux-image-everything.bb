DESCRIPTION = "OSL image definition for Xilinx boards"
LICENSE = "MIT"

require petalinux-image-full.inc

# Native dependencies we want to make sure we can build
DEPENDS:append = " \
	protobuf-native \
	libeigen-native \
	python3-setuptools-native \
	unfs3-native \
"

# Nativesdk dependencies we want to make sure we can build
PLNX_ADDON_SDK = "nativesdk-unfs3"
PLNX_ADDON_SDK:sdkmingw32 = ""

DEPENDS:append = " \
	${PLNX_ADDON_SDK} \
"

DEPENDS:append:zynq   = " libeigen"
DEPENDS:append:zynqmp = " libeigen"
DEPENDS:append:versal = " libeigen"

# We include docker (via IMAGE_FEATURES and packagegroup-ocicontainers)
# but also want docker-compose to be available.  Use same switch method.
IMAGE_INSTALL:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization vmsep', ' python3-docker-compose', '', d)}"

# Add ltp package
IMAGE_INSTALL:append = " ltp"

IMAGE_INSTALL:append:zynq = " kernel-devsrc"

VITISAI_DEPENDENCIES = "opencv googletest protobuf-c boost json-c libunwind"
IMAGE_INSTALL:append:zynqmp = " ${VITISAI_DEPENDENCIES} xrt hellopm cppzmq-dev jansson kernel-devsrc mosquitto kernel-module-dp kernel-module-hdmi"
IMAGE_INSTALL:append:zynqmp = "${@bb.utils.contains('DISTRO_FEATURES', 'openamp', ' openamp-demo-notebooks', '', d)}"
IMAGE_INSTALL:append:zynqmp = "${@bb.utils.contains('MACHINE_FEATURES', 'vcu', ' gstreamer-vcu-examples gstreamer-vcu-notebooks', '', d)}"
IMAGE_INSTALL:append:zynqmp-dr = " sdfec rfdc rfdc-intr rfdc-read-write rfdc-selftest rfclk"

IMAGE_INSTALL:append:versal = " ${VITISAI_DEPENDENCIES} xrt kernel-devsrc pm-notebooks kernel-module-hdmi"
IMAGE_INSTALL:append:versal = "${@bb.utils.contains('MACHINE_FEATURES', 'vdu', ' gstreamer-vdu-examples gstreamer-vdu-notebooks', '', d)}"
IMAGE_INSTALL:append:versal = "${@bb.utils.contains('DISTRO_FEATURES', 'openamp', ' openamp-demo-notebooks', '', d)}"

# ultra96-zynqmp recipes
IMAGE_INSTALL:append:ultra96-zynqmp = " packagegroup-petalinux-ultra96-webapp"
IMAGE_INSTALL:append:ultra96-zynqmp = " ultra96-power-button"
IMAGE_INSTALL:append:ultra96-zynqmp = " packagegroup-petalinux-96boards-sensors"

IMAGE_INSTALL:append = " tree ttf-bitstream-vera packagegroup-core-full-cmdline python3-pybind11"

IMAGE_INSTALL:append = " python3-graphviz"

IMAGE_INSTALL:append = " bootgen"

IMAGE_INSTALL:append = " wolfssl"
