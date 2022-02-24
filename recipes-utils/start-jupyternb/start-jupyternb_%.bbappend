SRC_URI:ultra96 = "file://start-jupyter-ultra96.sh \
        file://jupyter_notebook_ultra96_config.py \
        file://jupyter-variables.sh \
        file://jupyter-setup.sh \
	file://jupyter-setup-ultra96.service \
	"
LIC_FILES_CHKSUM:ultra96 = "file://start-jupyter-ultra96.sh;beginline=2;endline=24;md5=25cc4ae6006012bbc275b3b0c6577996"

JUPYTER_STARTUP_PACKAGES:append:ultra96 = " ultra96-ap-setup"
RDEPENDS:${PN} = " ${JUPYTER_STARTUP_PACKAGES}"

INITSCRIPT_NAME:ultra96 = "jupyter-setup.sh"
INITSCRIPT_PARAMS:ultra96 = "start 99 S ."

SYSTEMD_SERVICE:${PN}:ultra96="jupyter-setup-ultra96.service"

inherit xilinx-pynq

do_install:ultra96() {

    sed -i -e 's|PLACEHOLDER|${BOARD_NAME}|g' ${WORKDIR}/jupyter-variables.sh

    if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
       install -d ${D}${sysconfdir}/init.d/
       install -m 0755 ${WORKDIR}/jupyter-setup.sh ${D}${sysconfdir}/init.d/jupyter-setup.sh

       install -d ${D}${sysconfdir}/profile.d/
        install -m 0755 ${WORKDIR}/jupyter-variables.sh ${D}${sysconfdir}/profile.d/jupyter-variables.sh
    fi

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/jupyter-setup-ultra96.service ${D}${systemd_system_unitdir}

    install -d ${D}${systemd_user_unitdir}
    install -m 0644 ${WORKDIR}/jupyter-setup-ultra96.service ${D}${systemd_user_unitdir}

    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/start-jupyter-ultra96.sh ${D}${base_sbindir}/start-jupyter.sh
    sed -i -e 's|PLACEHOLDER|${BOARD_NAME}|g' ${D}${base_sbindir}/start-jupyter.sh

    install -d ${D}${sysconfdir}/jupyter/
    install -m 0600 ${WORKDIR}/jupyter_notebook_ultra96_config.py ${D}${sysconfdir}/jupyter/jupyter_notebook_config.py
}

PACKAGE_ARCH:ultra96 = "${MACHINE_ARCH}"
