DESCRIPTION = "PetaLinux OpenAMP supported packages"

inherit packagegroup distro_features_check

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

RDEPENDS_${PN}_append_zynqmp = " \
	libmetal-demos \
	open-amp-demos \
	"
