DESCRIPTION = "PetaLinux OpenAMP supported packages"

PACKAGE_ARCH:versal = "${SOC_FAMILY_ARCH}"
PACKAGE_ARCH:zynqmp = "${SOC_FAMILY_ARCH}"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "openamp"

PACKAGES = "\
	packagegroup-petalinux-openamp-echo-test \
	packagegroup-petalinux-openamp-matrix-mul \
	packagegroup-petalinux-openamp-rpc-demo \
	packagegroup-petalinux-openamp \
	"

RDEPENDS:packagegroup-petalinux-openamp-echo-test = "\
	rpmsg-echo-test \
	openamp-fw-echo-testd \
	"

RDEPENDS:packagegroup-petalinux-openamp-matrix-mul = "\
	rpmsg-mat-mul \
	openamp-fw-mat-muld \
	"

RDEPENDS:packagegroup-petalinux-openamp-rpc-demo = "\
	rpmsg-proxy-app \
	openamp-fw-rpc-demo \
	"

RDEPENDS:${PN}:append = " \
	libmetal \
	open-amp \
	packagegroup-petalinux-openamp-echo-test \
	packagegroup-petalinux-openamp-matrix-mul \
	packagegroup-petalinux-openamp-rpc-demo \
	"

OPENAMP_FW_PACKAGES = " \
	openamp-fw-echo-testd \
	openamp-fw-mat-muld \
	openamp-fw-rpc-demo \
	"

RDEPENDS:${PN}:append:versal = " \
	${OPENAMP_FW_PACKAGES} \
	libmetal-demos \
	open-amp-demos \
	"

RDEPENDS:${PN}:append:zynqmp = " \
	${OPENAMP_FW_PACKAGES} \
	libmetal-demos \
	open-amp-demos \
	"
RDEPENDS:${PN}:remove:versal-generic = "${OPENAMP_FW_PACKAGES}"
RDEPENDS:${PN}:remove:zynqmp-generic = "${OPENAMP_FW_PACKAGES}"

