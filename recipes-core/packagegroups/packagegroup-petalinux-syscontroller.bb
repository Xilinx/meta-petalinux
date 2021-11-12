DESCRIPTION = "Required packages for system controller"

inherit packagegroup

SYSTEM_CONTROLLER_PACKAGES = " \
        python3-flask \
        python3-flask-restful \
        python3-werkzeug \
        python3-jinja2 \
        python3-markupsafe \
        python3-itsdangerous \
        python3-twisted \
        python3-gevent \
        python3-matplotlib \
        packagegroup-petalinux-lmsensors \
        i2c-tools \
        libgpiod \
        libgpiod-tools \
        system-controller-app \
"
RDEPENDS:${PN} = "${SYSTEM_CONTROLLER_PACKAGES}"

SYSTEM_CONTROLLER_PACKAGES:append:a2197 = " ${@'fru-tools' if 'xilinx-internal' in d.getVar('BBFILE_COLLECTIONS').split() else ''}"
SYSTEM_CONTROLLER_PACKAGES:append:vck-sc = " ${@'labtool-jtag-support' if 'xilinx-internal' in d.getVar('BBFILE_COLLECTIONS').split() else ''} power-advantage-tool"
