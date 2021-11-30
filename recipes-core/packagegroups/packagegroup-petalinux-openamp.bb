DESCRIPTION = "PetaLinux OpenAMP supported packages"

PACKAGE_ARCH:versal = "${SOC_FAMILY_ARCH}"
PACKAGE_ARCH:zynqmp = "${SOC_FAMILY_ARCH}"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "openamp"

OPENAMP_EXTRA_PACKAGES = " \
	libmetal \
	open-amp \
	rpmsg-echo-test \
	rpmsg-mat-mul \
	rpmsg-proxy-app \
	"

RDEPENDS:${PN}:append = " \
	${OPENAMP_EXTRA_PACKAGES} \
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

