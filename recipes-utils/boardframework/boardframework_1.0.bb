DESCRIPTION = "Python application to monitor voltages, clocks, power for versal boards"
SUMMARY = "Python application to monitor voltages, clocks, power for versal boards"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://../LICENSE;beginline=1;endline=23;md5=96049fee8887e8f457bca7d8472fd4a5"

SRC_URI = "git://gitenterprise.xilinx.com/sethm/BoardFramework.git;branch=master;protocol=https \
           file://LICENSE "

SRCREV="03f0fa15fb96515d91eb2010a0ddece754b47aa7"

SRC_URI[md5sum] = "30a3955eeb89f69b8fd56e67c04c787c"
SRC_URI[sha256sum] = "7b847e57d537a02d5d866d8af0302ef1411b061caf1e0adc2d2486d6929b8e98"

RDEPENDS_${PN} = "python3-periphery \
                  python3-pyserial \
                  python3-threading \
                  python3-pickle \
                  python3-pip \
                  python3-ruamel-yaml \
"

inherit update-rc.d

INITSCRIPT_NAME = "start_boardframework.sh"
INITSCRIPT_PARAMS = "start 98 5 ."

S="${WORKDIR}/git"

FILES_${PN} += "${datadir}/BoardFramework /usr/bin"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_vck-sc = "${MACHINE}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure[noexec]="1"
do_compile[noexec]="1"

do_install () {
    install -d ${D}${datadir}/BoardFramework/
    install -d ${D}${datadir}/BoardFramework/logs/
    install -d ${D}${sysconfdir}/init.d/
    install -d ${D}/usr/bin/

    cp -r  ${S}/src/* ${D}${datadir}/BoardFramework/
    chmod -R 755 ${D}${datadir}/BoardFramework/
    install -m 0755  ${S}/src/start_boardframework.sh ${D}/etc/init.d/
    install -m 0755  ${S}/src/boardframework.sh ${D}/usr/bin/boardframework.sh
    sed -i -e '/vccaux/s/^/#/' ${D}/usr/bin/boardframework.sh
    sed -i -e '/vadjautoset/s/^/#/' ${D}/usr/bin/boardframework.sh
    sed -i '1 i echo "******************************************************" > /dev/ttyPS0' ${D}${sysconfdir}/init.d/start_boardframework.sh
    sed -i '2 i echo "*  Enter these key-sequence to exit Board Framework  *" > /dev/ttyPS0' ${D}${sysconfdir}/init.d/start_boardframework.sh
    sed -i '3 i echo "*                                                    *" > /dev/ttyPS0' ${D}${sysconfdir}/init.d/start_boardframework.sh
    sed -i '4 i echo "*              EXT<Enter key><Tab key>               *" > /dev/ttyPS0' ${D}${sysconfdir}/init.d/start_boardframework.sh
    sed -i '5 i echo "******************************************************" > /dev/ttyPS0' ${D}${sysconfdir}/init.d/start_boardframework.sh
}
