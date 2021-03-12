PETALINUX_BSP ?= "${MACHINE}"
PETALINUX_PRODUCT ?= "${MACHINE}"
PETALINUX_VERSION ?= "${DISTRO_VERSION}"

FILESEXTRAPATHS_prepend  := "${THISDIR}/files:"

SRC_URI += "file://xilinx.sh"

dirs755_append = " ${sysconfdir}/${DISTRO} ${sysconfdir}/profile.d"

do_install_append () {
	echo "${PETALINUX_BSP}" > ${D}${sysconfdir}/${DISTRO}/bsp
	echo "${PETALINUX_PRODUCT}" > ${D}${sysconfdir}/${DISTRO}/product
	echo "${PETALINUX_VERSION}" > ${D}${sysconfdir}/${DISTRO}/version
	echo "${BB_CURRENT_MC}" > ${D}${sysconfdir}/${DISTRO}/config

        install -m 0755 ${WORKDIR}/xilinx.sh ${D}${sysconfdir}/profile.d/xilinx.sh
}

CONFFILES_${PN}_append = " \
	${sysconfdir}/${DISTRO}/bsp \
	${sysconfdir}/${DISTRO}/config \
	${sysconfdir}/${DISTRO}/product \
	${sysconfdir}/${DISTRO}/version \
	"
