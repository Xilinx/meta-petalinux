PETALINUX_VERSION ?= "${DISTRO_VERSION}"

SUMMARY = "Petalinux identification files for the base system"
DESCRIPTION = "Identify the configuration that was used to generate this rootfs"
SECTION = "base"
PV = "${PETALINUX_VERSION}"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

INHIBIT_DEFAULT_DEPS = "1"

# We assume the machine is generic and the swtiching is based on board or soc variants.
SOC_FAMILY_ARCH ??= "${TUNE_PKGARCH}"
SOC_VARIANT_ARCH ??= "${SOC_FAMILY_ARCH}"
PACKAGE_ARCH = "${SOC_VARIANT_ARCH}"

do_configure[noexec] = '1'
do_compile[noexec] = '1'

do_install () {
        install -d -m 0755 ${D}${sysconfdir}/${DISTRO}

        if [ "${SOC_FAMILY}" != "" ]; then
	    echo "${SOC_FAMILY}-${SOC_VARIANT}" > ${D}${sysconfdir}/${DISTRO}/soc
        fi
}

FILES_${PN} = "${sysconfdir}/${DISTRO}"
CONFFILES_${PN} = " \
	${sysconfdir}/${DISTRO}/soc \
	"
