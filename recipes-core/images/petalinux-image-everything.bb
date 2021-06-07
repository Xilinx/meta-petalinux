DESCRIPTION = "OSL image definition for Xilinx boards"
LICENSE = "MIT"

require petalinux-image-full.inc

DEPENDS_append = " protobuf-native libeigen-native python3-setuptools-native"
DEPENDS_append_zynq   = " libeigen"
DEPENDS_append_zynqmp = " libeigen"
DEPENDS_append_versal = " libeigen"

IMAGE_INSTALL_append_zynq = " kernel-devsrc xrt"

VITISAI_DEPENDENCIES = "opencv googletest protobuf-c boost json-c libunwind"
IMAGE_INSTALL_append_zynqmp = " ${VITISAI_DEPENDENCIES} xrt openamp-demo-notebooks watchdog-init hellopm cppzmq-dev jansson packagegroup-petalinux-som kernel-devsrc kernel-module-hdmi kernel-module-dp"
IMAGE_INSTALL_append_zynqmp-ev = " gstreamer-vcu-examples gstreamer-vcu-notebooks"
IMAGE_INSTALL_append_zynqmp-dr = " sdfec rfdc rfdc-intr rfdc-read-write rfdc-selftest rfclk"

IMAGE_INSTALL_append_versal = " ${VITISAI_DEPENDENCIES} xrt pm-notebooks openamp-demo-notebooks kernel-devsrc kernel-module-hdmi"
IMAGE_INSTALL_append_versal-ai-core = " aie-notebooks"

# ultra96-zynqmp recipes
IMAGE_INSTALL_append_ultra96 = " sensors96b-overlays-notebooks packagegroup-petalinux-ultra96-webapp"
IMAGE_INSTALL_append_ultra96 = " ultra96-startup-pages ultra96-ap-setup ultra96-power-button"
IMAGE_INSTALL_append_ultra96 = " sensor-mezzanine-examples"

# vck-sc-zynqmp recipes
#IMAGE_INSTALL_append_vck-sc = " acap power-advantage-tool labtool-jtag-support boardframework packagegroup-petalinux-syscontroller packagegroup-petalinux-scweb"

IMAGE_INSTALL_append_versal-generic = " cmc-deploy-vck5000"
IMAGE_INSTALL_append_zynqmp-generic = " cmc-deploy-u30"

IMAGE_INSTALL_append = " tree ttf-bitstream-vera packagegroup-core-full-cmdline"

KV260_PACKAGES = " \
	packagegroup-kv260-aibox-reid \
	packagegroup-kv260-defect-detect \
	packagegroup-kv260-nlp-smartvision \
	packagegroup-kv260-smartcam \
	"
#IMAGE_INSTALL_append_k26-kv = " ${KV260_PACKAGES}"
