PETALINUX_BSP ?= "${MACHINE}"
PETALINUX_PRODUCT ?= "${MACHINE}"
PETALINUX_VERSION ?= "${DISTRO_VERSION}"

SUMMARY = "Petalinux identification files for the base system"
DESCRIPTION = "Identify the configuration that was used to generate this rootfs"
SECTION = "base"
PV = "${PETALINUX_VERSION}"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

INHIBIT_DEFAULT_DEPS = "1"

# We assume the machine is generic and the swtiching is based on board or soc variants.
PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure[noexec] = '1'
do_compile[noexec] = '1'

do_install () {
        install -d -m 0755 ${D}${sysconfdir}/${DISTRO}

	echo "${PETALINUX_BSP}" > ${D}${sysconfdir}/${DISTRO}/bsp
	echo "${PETALINUX_PRODUCT}" > ${D}${sysconfdir}/${DISTRO}/product
	echo "${PETALINUX_VERSION}" > ${D}${sysconfdir}/${DISTRO}/version
}

RRECOMMENDS_${PN} = "base-files-board base-files-board-variant base-files-soc"
FILES_${PN} = "${sysconfdir}/${DISTRO}"
CONFFILES_${PN} = " \
	${sysconfdir}/${DISTRO}/bsp \
	${sysconfdir}/${DISTRO}/product \
	${sysconfdir}/${DISTRO}/version \
	"
