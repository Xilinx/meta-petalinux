SRC_URI_ultra96-zynqmp = "file://start-jupyter-ultra96.sh \
        file://jupyter_notebook_ultra96_config.py \
        file://jupyter-variables.sh \
        file://jupyter-setup.sh \
	"
LIC_FILES_CHKSUM_ultra96-zynqmp = "file://start-jupyter-ultra96.sh;beginline=2;endline=24;md5=25cc4ae6006012bbc275b3b0c6577996"

JUPYTER_STARTUP_PACKAGES_append_ultra96-zynqmp = " ultra96-ap-setup"
RDEPENDS_${PN} = " ${JUPYTER_STARTUP_PACKAGES}"

INITSCRIPT_NAME_ultra96-zynqmp = "jupyter-setup.sh"
INITSCRIPT_PARAMS_ultra96-zynqmp = "start 99 S ."

inherit xilinx-pynq

do_install_ultra96-zynqmp() {

    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/jupyter-setup.sh ${D}${sysconfdir}/init.d/jupyter-setup.sh

    install -d ${D}${sysconfdir}/profile.d/
    install -m 0755 ${WORKDIR}/jupyter-variables.sh ${D}${sysconfdir}/profile.d/jupyter-variables.sh
    sed -i -e 's|PLACEHOLDER|${BOARD_NAME}|g' ${D}${sysconfdir}/profile.d/jupyter-variables.sh

    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/start-jupyter-ultra96.sh ${D}${base_sbindir}/start-jupyter.sh
    sed -i -e 's|PLACEHOLDER|${BOARD_NAME}|g' ${D}${base_sbindir}/start-jupyter.sh

    install -d ${D}${sysconfdir}/jupyter/
    install -m 0600 ${WORKDIR}/jupyter_notebook_ultra96_config.py ${D}${sysconfdir}/jupyter/jupyter_notebook_config.py
}
