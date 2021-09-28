DESCRIPTION = "OSL image definition for Xilinx boards"
LICENSE = "MIT"

require petalinux-image-full.inc

DEPENDS_append = " protobuf-native libeigen-native python3-setuptools-native"
DEPENDS_append_zynq   = " libeigen"
DEPENDS_append_zynqmp = " libeigen"
DEPENDS_append_versal = " libeigen"

# We include docker (via IMAGE_FEATURES and packagegroup-ocicontainers)
# but also want docker-compose to be available.  Use same switch method.
IMAGE_INSTALL_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization vmsep', ' python3-docker-compose', '', d)}"

IMAGE_INSTALL_append_zynq = " kernel-devsrc xrt"

VITISAI_DEPENDENCIES = "opencv googletest protobuf-c boost json-c libunwind"
IMAGE_INSTALL_append_zynqmp = " ${VITISAI_DEPENDENCIES} xrt openamp-demo-notebooks watchdog-init hellopm cppzmq-dev jansson kernel-devsrc kernel-module-hdmi kernel-module-dp mosquitto"
IMAGE_INSTALL_append_zynqmp-ev = " gstreamer-vcu-examples gstreamer-vcu-notebooks"
IMAGE_INSTALL_append_zynqmp-dr = " sdfec rfdc rfdc-intr rfdc-read-write rfdc-selftest rfclk"

IMAGE_INSTALL_append_versal = " ${VITISAI_DEPENDENCIES} xrt pm-notebooks openamp-demo-notebooks kernel-devsrc kernel-module-hdmi"

# ultra96-zynqmp recipes
IMAGE_INSTALL_append_ultra96 = " sensors96b-overlays-notebooks packagegroup-petalinux-ultra96-webapp"
IMAGE_INSTALL_append_ultra96 = " ultra96-startup-pages ultra96-ap-setup ultra96-power-button"
IMAGE_INSTALL_append_ultra96 = " sensor-mezzanine-examples"

IMAGE_INSTALL_append_vck-sc = " power-advantage-tool boardframework packagegroup-petalinux-syscontroller packagegroup-petalinux-scweb"

# vpk-sc recipes
IMAGE_INSTALL_append_vpk-sc = " power-advantage-tool boardframework packagegroup-petalinux-syscontroller packagegroup-petalinux-scweb"

IMAGE_INSTALL_append = " tree ttf-bitstream-vera packagegroup-core-full-cmdline"

KV260_PACKAGES = " \
	packagegroup-kv260-aibox-reid \
	packagegroup-kv260-defect-detect \
	packagegroup-kv260-nlp-smartvision \
	packagegroup-kv260-smartcam \
	kv260-dpu-benchmark \
	"
#IMAGE_INSTALL_append_k26-kv = " ${KV260_PACKAGES}"
