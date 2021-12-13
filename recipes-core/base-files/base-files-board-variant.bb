SUMMARY = "Petalinux identification files for the base system"
DESCRIPTION = "Identify the configuration that was used to generate this rootfs"
SECTION = "base"
PV = "${PETALINUX_VERSION}"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

INHIBIT_DEFAULT_DEPS = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure[noexec] = '1'
do_compile[noexec] = '1'

do_install () {
        install -d -m 0755 ${D}${sysconfdir}/${DISTRO}

        echo "${MACHINEOVERRIDES}" > ${D}${sysconfdir}/${DISTRO}/board-variant
}

FILES:${PN} = "${sysconfdir}/${DISTRO}"
CONFFILES:${PN} = " \
	${sysconfdir}/${DISTRO}/board-variant \
	"
