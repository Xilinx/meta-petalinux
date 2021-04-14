SUMMARY = "Jupyter-lab user configuration file"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://jupyter_notebook_config.py"

RDEPENDS_${PN} = "python3-jupyterlab"

S = "${WORKDIR}"

do_install() {
	install -d ${D}/opt/xilinx/share/notebooks
	install -d -m 0700 ${D}${sysconfdir}/skel/.jupyter
	install -m 0600 ${WORKDIR}/jupyter_notebook_config.py ${D}/${sysconfdir}/skel/.jupyter
}

FILES_${PN} += " \
	${sysconfdir}/skel/.jupyter \
	/opt/xilinx/share/notebooks \
	"
