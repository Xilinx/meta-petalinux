SUMMARY = "Start Jupyter at system boot"

SRC_URI = " file://start-jupyter.sh \
            file://jupyter-setup.sh \
            file://jupyter_notebook_config.py \
	"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://start-jupyter.sh;beginline=2;endline=24;md5=f29b6e59838b939312f578e77087ada3"

JUPYTER_STARTUP_PACKAGES += " \
        python3-jupyter-core \
        bash \
        "

inherit update-rc.d
RDEPENDS_${PN} = " ${JUPYTER_STARTUP_PACKAGES}"

INITSCRIPT_NAME = "jupyter-setup.sh"
INITSCRIPT_PARAMS = "start 99 S ."

S = "${WORKDIR}"

FILES_${PN} += "${base_sbindir}"

do_install() {
    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/jupyter-setup.sh ${D}${sysconfdir}/init.d/jupyter-setup.sh

    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/start-jupyter.sh ${D}${base_sbindir}/start-jupyter.sh

    install -d ${D}${sysconfdir}/jupyter/
    install -m 0600 ${WORKDIR}/jupyter_notebook_config.py ${D}${sysconfdir}/jupyter
}
