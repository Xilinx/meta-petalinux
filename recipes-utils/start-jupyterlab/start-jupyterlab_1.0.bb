#
# This is the jupyter-lab startup daemon
#

SUMMARY = "Start Jupyter-lab server at system boot"

SRC_URI = " \
	file://jupyter_notebook_config.py \
	file://jupyter-setup.sh \
	file://overrides.json \
	file://start-jupyter.sh \
	"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

JUPYTER_STARTUP_PACKAGES += " \
	python3-jupyterlab \
	bash \
	procps \
	"

RDEPENDS:${PN} = " ${JUPYTER_STARTUP_PACKAGES}"

PROVIDES = "start-jupyter"
RPROVIDES:${PN} = "start-jupyter"

inherit update-rc.d

INITSCRIPT_NAME = "jupyter-setup.sh"
INITSCRIPT_PARAMS = "start 99 3 5 . stop 20 0 1 2 6 ."

S = "${WORKDIR}"

do_install() {
    install -d ${D}${datadir}/jupyter/lab/settings
    install -m 0644 ${WORKDIR}/overrides.json ${D}${datadir}/jupyter/lab/settings/

    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/jupyter-setup.sh ${D}${sysconfdir}/init.d/jupyter-setup.sh

    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/start-jupyter.sh ${D}${base_sbindir}/start-jupyter.sh

    install -d ${D}${sysconfdir}/jupyter/
    install -m 0600 ${WORKDIR}/jupyter_notebook_config.py ${D}${sysconfdir}/jupyter
}

FILES:${PN} += " \
	${base_sbindir} \
	${datadir}/jupyter/lab/settings \
	"
