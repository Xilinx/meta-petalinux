DESCRIPTION = "PetaLinux boardframework packages"

inherit packagegroup

# Packages
PYTHON_PACKAGES = " \
	packagegroup-petalinux-python-modules \
	boardframework \
	"

RDEPENDS_${PN} = "${PYTHON_PACKAGES}"

