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
        packagegroup-petalinux-lmsensors \
        i2c-tools \
        libgpiod \
        fru-tools \
"
RDEPENDS_${PN} = "${SYSTEM_CONTROLLER_PACKAGES}"
