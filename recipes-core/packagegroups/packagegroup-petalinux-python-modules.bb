DESCRIPTION = "PetaLinux python module packages"

inherit packagegroup

# Packages
PYTHON_MODULES = " \
	python3-pip\
	python3-multiprocessing \
	python3-numpy \
	python3-shell \
	python3-threading \
	python3-threading \
	python3-pyserial \
	python3-h5py \
	"

RDEPENDS_${PN} = "${PYTHON_MODULES}"

