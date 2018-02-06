DESCRIPTION = "PetaLinux python module packages"

inherit packagegroup

# Packages
PYTHON_MODULES = " \
	python3-pip\
	python-pip \
	python-multiprocessing \
	python-numpy \
	python-scons \
	python-shell \
	python-threading \
	python3-pyserial \
	python-pyserial \
	"

RDEPENDS_${PN} = "${PYTHON_MODULES}"

