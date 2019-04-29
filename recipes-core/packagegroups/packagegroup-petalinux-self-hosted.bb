DESCRIPTION = "PetaLinux self hosted tools packages"

inherit packagegroup distro_features_check
REQUIRED_DISTRO_FEATURES = "x11 opengl"

SELF_HOSTED_PACKAGES = " \
	packagegroup-self-hosted \
	vim \
	"

RDEPENDS_${PN} = "${SELF_HOSTED_PACKAGES}"
