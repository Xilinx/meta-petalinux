SUMMARY = "Simple cmc application deploy"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/cmc-deploy:"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_versal = ".*"

RDEPENDS_${PN} = "libmetal"
XILINX_RELEASE_VERSION="2021.2"
CMCPATH="/proj/yocto/${XILINX_RELEASE_VERSION}/cmc/vck5000-versal/cmc_latest"

SRC_URI = " \
       file://${CMCPATH} \
       file://cmc-start.sh \
       file://cmc-start.service \
"

inherit update-rc.d systemd 

INITSCRIPT_NAME = "cmc-start.sh"
INITSCRIPT_PARAMS = "start 99 S ."

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE_${PN}="cmc-start.service"
SYSTEMD_AUTO_ENABLE_${PN}="enable"

do_install() {
	install -d ${D}${bindir}
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${CMCPATH}/cmc ${D}${bindir}

        if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
               install -m 0755 ${WORKDIR}/cmc-start.sh ${D}${sysconfdir}/init.d/cmc-start.sh
        fi
 
       install -d ${D}${systemd_system_unitdir}
       install -m 0644 ${WORKDIR}/cmc-start.service ${D}${systemd_system_unitdir}
}

FILES_${PN} += "${bindir}/cmc ${sysconfdir}/init.d/cmc-start.sh"
SIGGEN_EXCLUDE_SAFE_RECIPE_DEPS += "cmc-deploy-vck5000->libmetal"
