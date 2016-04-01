FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
	file://0001-mtd_probe.h-Add-stdint.h-as-it-was-removed-from-mtd-.patch \
	file://0002-configure.ac-Makefile.am-Check-for-input.h-and-input.patch \
	"
