DESCRIPTION = "Python application to monitor voltages, clocks, power for versal boards"
SUMMARY = "Python application to monitor voltages, clocks, power for versal boards"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://../LICENSE;beginline=1;endline=27;md5=783f0ad9d0cdfd553f68250d61daa99f"

SRC_URI = "git://gitenterprise.xilinx.com/sethm/BoardFramework.git;branch=master;protocol=https \
           file://LICENSE "

SRCREV="c3277725cb84aa1318b7b20661bdc5bab68719e5"

SRC_URI[md5sum] = "30a3955eeb89f69b8fd56e67c04c787c"
SRC_URI[sha256sum] = "7b847e57d537a02d5d866d8af0302ef1411b061caf1e0adc2d2486d6929b8e98"

RDEPENDS_${PN} = "python3-periphery \
                  python3-pyserial \
                  python3-threading \
                  python3-pickle \
                  python3-pip \
"
inherit update-rc.d

INITSCRIPT_NAME = "start_boardframework.sh"
INITSCRIPT_PARAMS = "start 99 S ."

S="${WORKDIR}/git"

FILES_${PN} += "${datadir}/Board_Framework_Phase1Alpha /usr/bin"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_a2197-zynqmp = "a2197-zynqmp"

do_configure[noexec]="1"
do_compile[noexec]="1"

do_install () {
    install -d ${D}${datadir}/Board_Framework_Phase1Alpha
    install -d ${D}${sysconfdir}/init.d/
    install -d ${D}/usr/bin/

    install -m 0755  ${S}/src/* ${D}${datadir}/Board_Framework_Phase1Alpha
    install -m 0755  ${S}/src/start_boardframework.sh ${D}/etc/init.d/
    install -m 0755  ${S}/src/boardframework.sh ${D}/usr/bin/boardframework.sh
}
