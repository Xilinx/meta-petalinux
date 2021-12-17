#
# This file is the Power Management Tool for system controller recipe.
#

SUMMARY = "Power Management Tool"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://../LICENSE.md;beginline=1;endline=21;md5=17b8e1d4035e928378878301dbf1d92c"


SRC_URI = "git://github.com/Xilinx/system-controller-pmtool.git;protocol=https;branch=master \
                               file://LICENSE.md \
		               file://pmtool.conf \
                  "

SRCREV = "9d0cc459dc4b3bbf283fb8dbc6bbaaaec6d2cb34"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:vck-sc = "${MACHINE}"
COMPATIBLE_MACHINE:vpk-sc = "${MACHINE}"
COMPATIBLE_MACHINE:eval-brd-sc = "${MACHINE}"
PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure[noexec]="1"
do_compile[noexec]="1"

RDEPENDS:${PN} += " \
        apache2 \
        "

do_install() {
        install -d ${D}/var/www/pmtool/
        cp -r ${S}/* ${D}/var/www/pmtool/

        install -d ${D}${sysconfdir}/apache2/conf.d/
        cp -r ${WORKDIR}/pmtool.conf ${D}${sysconfdir}/apache2/conf.d/

}
FILES:${PN} += "/var/www/pmtool"
FILES:${PN} += "${sysconfdir}/apache2/conf.d"


