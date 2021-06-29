SRC_URI_ultra96 = "file://start-jupyter-ultra96.sh \
        file://jupyter_notebook_ultra96_config.py \
        file://jupyter-variables.sh \
        file://jupyter-setup.sh \
	file://jupyter-setup-ultra96.service \
	"
LIC_FILES_CHKSUM_ultra96 = "file://start-jupyter-ultra96.sh;beginline=2;endline=24;md5=25cc4ae6006012bbc275b3b0c6577996"

JUPYTER_STARTUP_PACKAGES_append_ultra96 = " ultra96-ap-setup"
RDEPENDS_${PN} = " ${JUPYTER_STARTUP_PACKAGES}"

INITSCRIPT_NAME_ultra96 = "jupyter-setup.sh"
INITSCRIPT_PARAMS_ultra96 = "start 99 S ."

SYSTEMD_SERVICE_${PN}_ultra96-zynqmp="jupyter-setup-ultra96.service"

inherit xilinx-pynq

do_install_ultra96() {

    sed -i -e 's|PLACEHOLDER|${BOARD_NAME}|g' ${WORKDIR}/jupyter-variables.sh

    if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
       install -d ${D}${sysconfdir}/init.d/
       install -m 0755 ${WORKDIR}/jupyter-setup.sh ${D}${sysconfdir}/init.d/jupyter-setup.sh

       install -d ${D}${sysconfdir}/profile.d/
        install -m 0755 ${WORKDIR}/jupyter-variables.sh ${D}${sysconfdir}/profile.d/jupyter-variables.sh
    fi

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/jupyter-setup-ultra96.service ${D}${systemd_system_unitdir}

    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/start-jupyter-ultra96.sh ${D}${base_sbindir}/start-jupyter.sh
    sed -i -e 's|PLACEHOLDER|${BOARD_NAME}|g' ${D}${base_sbindir}/start-jupyter.sh

    install -d ${D}${sysconfdir}/jupyter/
    install -m 0600 ${WORKDIR}/jupyter_notebook_ultra96_config.py ${D}${sysconfdir}/jupyter/jupyter_notebook_config.py
}

PACKAGE_ARCH_ultra96 = "${BOARD_ARCH}"
