DESCRIPTION = "Required packges for running jupyter notebook with python3 "

inherit packagegroup

JUPYTER_NOTEBOOK_PACKAGES = " \
	packagegroup-python3-jupyter \
	python3-runpy \
	"

RDEPENDS_${PN} = "${JUPYTER_NOTEBOOK_PACKAGES}"
