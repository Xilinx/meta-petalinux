DESCRIPTION = "PetaLinux python module packages"

inherit packagegroup

# Packages
PYTHON_MODULES = " \
	python3-pip\
	python-pip \
	python-multiprocessing \
	python3-multiprocessing \
	python3-numpy \
	python-shell \
	python3-shell \
	python-threading \
	python3-threading \
	python3-pyserial \
	python-pyserial \
	"

RDEPENDS_${PN} = "${PYTHON_MODULES}"

