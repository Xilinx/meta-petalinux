DESCRIPTION = "Python application to monitor voltages, clocks, power for versal boards"
SUMMARY = "Python application to monitor voltages, clocks, power for versal boards"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://../LICENSE;beginline=1;endline=27;md5=783f0ad9d0cdfd553f68250d61daa99f"

SRC_URI = "git://gitenterprise.xilinx.com/sethm/BoardFramework.git;branch=master;protocol=https \
           file://LICENSE "

SRCREV="04647dc69181df93058dc449241e52d22bb72c7b"

SRC_URI[md5sum] = "30a3955eeb89f69b8fd56e67c04c787c"
SRC_URI[sha256sum] = "7b847e57d537a02d5d866d8af0302ef1411b061caf1e0adc2d2486d6929b8e98"

RDEPENDS_${PN} = "python3-periphery \
                  python3-pyserial \
                  python3-threading \
                  python3-pickle \
                  python3-pip \
"

S="${WORKDIR}/git"

FILES_${PN} += "${datadir}/Board_Framework_Phase1Alpha"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_a2197-zynqmp = "a2197-zynqmp"

do_configure[noexec]="1"
do_compile[noexec]="1"

do_install () {
    install -d ${D}${datadir}/Board_Framework_Phase1Alpha
    cp -r  ${S}/src/* ${D}${datadir}/Board_Framework_Phase1Alpha
}
