DESCRIPTION = "PetaLinux OpenAMP supported packages"

PACKAGE_ARCH_versal = "${SOC_FAMILY_ARCH}"
PACKAGE_ARCH_zynqmp = "${SOC_FAMILY_ARCH}"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "openamp"

OPENAMP_EXTRA_PACKAGES = " \
	libmetal \
	open-amp \
	rpmsg-echo-test \
	rpmsg-mat-mul \
	rpmsg-proxy-app \
	"

RDEPENDS_${PN}_append = " \
	${OPENAMP_EXTRA_PACKAGES} \
	"

OPENAMP_FW_PACKAGES = " \
	openamp-fw-echo-testd \
	openamp-fw-mat-muld \
	openamp-fw-rpc-demo \
	"

RDEPENDS_${PN}_append_versal = " \
	${OPENAMP_FW_PACKAGES} \
	libmetal-demos \
	open-amp-demos \
	"

RDEPENDS_${PN}_append_zynqmp = " \
	${OPENAMP_FW_PACKAGES} \
	libmetal-demos \
	open-amp-demos \
	"
RDEPENDS_${PN}_remove_versal-generic = "${OPENAMP_FW_PACKAGES}"
RDEPENDS_${PN}_remove_zynqmp-generic = "${OPENAMP_FW_PACKAGES}"

