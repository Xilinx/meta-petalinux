DESCRIPTION = "PetaLinux system controller scweb app packages"

inherit packagegroup

# Packages
SYS_CONTROLLER_SCWEB_PACKAGES = " \
        python3 \
        python3-flask \
        python3-flask-restful \
        packagegroup-petalinux-syscontroller \
        packagegroup-petalinux-lmsensors \
        pmtool \
        scweb \
       "

RDEPENDS:${PN} = "${SYS_CONTROLLER_SCWEB_PACKAGES}"
