DESCRIPTION = "System Contoller App"
SUMMARY = "System Controller App"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://../LICENSE;beginline=1;endline=23;md5=24248f11cbed04b4a7a0609c5d0ff97a"

SRC_URI = "git://gitenterprise.xilinx.com/Platform-Management/system-controller.git;branch=master;protocol=https \
		   file://LICENSE "

SRCREV="74c7ae2a0163247422a1d9af613d6ac014f5acdc"

inherit update-rc.d

INITSCRIPT_NAME = "system_controller.sh"
INITSCRIPT_PARAMS = "start 99 S ."

S="${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_vck-sc-zynqmp = "vck-sc-zynqmp"

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS += "libgpiod"

do_compile(){
	cd ${S}/build/
	oe_runmake
}

do_install(){
	install -d ${D}/usr/bin/
	install -d ${D}${sysconfdir}/init.d/
	install -d ${D}${datadir}/system-controller-app

	cp ${S}/build/sc_app ${D}/usr/bin/
	cp ${S}/build/sc_appd ${D}/usr/bin/
	cp -r ${S}/BIT ${D}${datadir}/system-controller-app/
	install -m 0755 ${S}/src/system_controller.sh ${D}${sysconfdir}/init.d/
}

FILES_${PN} += "${datadir}/system-controller-app /usr/bin"
