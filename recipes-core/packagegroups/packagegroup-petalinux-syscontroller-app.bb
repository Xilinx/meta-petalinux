DESCRIPTION = "PetaLinux system controller app packages"

inherit packagegroup

# Packages
SYS_CONTROLLER_APP_PACKAGES = " \
	libgpiod \
	system-controller-app \
	"

RDEPENDS_${PN} = "${SYS_CONTROLLER_APP_PACKAGES}"

