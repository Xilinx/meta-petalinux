#
# This recipe installs start script hellopm.sh in /usr/bin directory
#

DESCRIPTION = "This is a Power management Linux application which will allow user to do various operations such as suspend,wakeup,reboot,shutdown the system."
SUMMARY = "Hello PM Management Linux Application"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://hellopm.sh;beginline=3;endline=38;md5=60d580d3edae5674cb19d747773123d8"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

SRC_URI = "\
	file://hellopm.sh \
	"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"

S = "${WORKDIR}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install() {
	install -Dm 0755 ${S}/hellopm.sh ${D}${bindir}/hellopm
}

PACKAGE_ARCH = "${SOC_FAMILY}"
