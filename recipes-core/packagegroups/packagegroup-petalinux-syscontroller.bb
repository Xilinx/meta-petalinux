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
RDEPENDS_${PN} = "${SYSTEM_CONTROLLER_PACKAGES}"

SYSTEM_CONTROLLER_PACKAGES_append_a2197 = " fru-tools"
SYSTEM_CONTROLLER_PACKAGES_append_vck-sc = "labtool-jtag-support power-advantage-tool"
