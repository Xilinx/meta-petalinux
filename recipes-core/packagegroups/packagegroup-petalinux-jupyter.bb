DESCRIPTION = "Required packges for running jupyter notebook with python3 "

inherit packagegroup

START_JUPYTER_PKG ?= "start-jupyter"
START_JUPYTER_PKG_k26 = "start-jupyterlab"

JUPYTER_NOTEBOOK_PACKAGES = " \
	packagegroup-python3-jupyter \
	python3-core \
	python3-ipywidgets \
	python3-pydot \
	liberation-fonts \
	ttf-bitstream-vera \
	${START_JUPYTER_PKG} \
	"

RDEPENDS_${PN} = "${JUPYTER_NOTEBOOK_PACKAGES}"
