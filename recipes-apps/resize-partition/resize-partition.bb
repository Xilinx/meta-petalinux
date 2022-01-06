
DESCRIPTION = "Init script to extend the rootfs partition size \
		during runtime"

SUMMARY = "Init script to extend the rootfs partition size \
                during runtime \
                "

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://resize-partition.sh \
	   file://resize-partition.service \
"

inherit update-rc.d systemd

RDEPENDS:${PN} += "resize-part"

INSANE_SKIP:${PN} += "installed-vs-shipped"

INITSCRIPT_NAME = "resize-partition.sh"
INITSCRIPT_PARAMS = "start 99 S ."

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "resize-partition.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp = "zynqmp"

do_install () {
        if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
                install -d ${D}${sysconfdir}/init.d/
                install -m 0755 ${WORKDIR}/resize-partition.sh ${D}${sysconfdir}/init.d/
        fi
 
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/resize-partition.sh ${D}${bindir}/
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/resize-partition.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "${@bb.utils.contains('DISTRO_FEATURES','sysvinit','${sysconfdir}/init.d/resize-partition.sh', '', d)}"
