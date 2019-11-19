DESCRIPTION = "Required packges for running jupyter notebook with python3 "

inherit packagegroup

JUPYTER_NOTEBOOK_PACKAGES = " \
	packagegroup-python3-jupyter \
	python3-core \
	python3-ipywidgets \
	liberation-fonts \
	start-jupyter \
	"

RDEPENDS_${PN} = "${JUPYTER_NOTEBOOK_PACKAGES}"
