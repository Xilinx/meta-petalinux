DESCRIPTION = "System Contoller App"
SUMMARY = "System Controller App"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/Xilinx/system-controller-app.git;branch=master;protocol=https \
           file://system_controller.service \
"

SRCREV="71d22c14fa7752a5fdae7e0f5776a9f36777e1ff"

inherit update-rc.d systemd

INITSCRIPT_NAME = "system_controller.sh"
INITSCRIPT_PARAMS = "start 96 5 ."

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE_${PN}="system_controller.service"
SYSTEMD_AUTO_ENABLE_${PN}="enable"

S="${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_vck-sc = "${MACHINE}"
COMPATIBLE_MACHINE_a2197 = "${MACHINE}"
COMPATIBLE_MACHINE_vpk-sc = "${MACHINE}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS += "libgpiod"

do_compile(){
	cd ${S}/build/
	oe_runmake
}

do_install(){
	install -d ${D}/usr/bin/
	install -d ${D}${datadir}/system-controller-app

	cp ${S}/build/sc_app ${D}${bindir}
	cp ${S}/build/sc_appd ${D}${bindir}
	cp -r ${S}/BIT ${D}${datadir}/system-controller-app/
	cp -r ${S}/board ${D}${datadir}/system-controller-app/

	install -m 0755 ${S}/src/system_controller.sh ${D}${bindir}
	install -d ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/system_controller.service ${D}${systemd_system_unitdir}

	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/init.d/
		install -m 0755 ${S}/src/system_controller.sh ${D}${sysconfdir}/init.d/
		rm -rf ${D}{bindir}/system_controller.sh
	fi
}
