DESCRIPTION = "Required packges for running jupyter notebook with python3 "

inherit packagegroup

JUPYTER_NOTEBOOK_PACKAGES = " \
	packagegroup-python3-jupyter \
	python3-core \
	python3-ipywidgets \
	python3-pydot \
	liberation-fonts \
	start-jupyter \
	ttf-bitstream-vera \
	"

RDEPENDS_${PN} = "${JUPYTER_NOTEBOOK_PACKAGES}"
