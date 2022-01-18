DESCRIPTION = "ARCHCONFIG"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit update-rc.d systemd

RDEPENDS:${PN} = "bash fru-print dnf"

INITSCRIPT_NAME = "archconfig.sh"
INITSCRIPT_PARAMS = "start 99 S ."
SRC_URI = "file://archconfig.sh \
	   file://archconfig.service \
"

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE:${PN}="archconfig.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"



do_install() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/init.d/
		install -m 0755 ${WORKDIR}/archconfig.sh ${D}${sysconfdir}/init.d/
	fi

       install -d ${D}${systemd_system_unitdir} 
       install -d ${D}${bindir} 

       install -m 0644 ${WORKDIR}/archconfig.service ${D}${systemd_system_unitdir}
       install -m 0755 ${WORKDIR}/archconfig.sh ${D}${bindir}
}

do_configure() {
        sed -i -e "s|@@PACKAGE_FEED_URIS@@|${PACKAGE_FEED_URIS}|g" "${WORKDIR}/archconfig.sh"
}

FILES:${PN} += "${@bb.utils.contains('DISTRO_FEATURES','sysvinit','${sysconfdir}/init.d/archconfig.sh', '', d)} ${systemd_system_unitdir}"
