DESCRIPTION = "PetaLinux  Enlightenment Window Manager + the Illume environment related Packages"
LICENSE = "NONE"
SECTION = "x11/wm"

inherit packagegroup distro_features_check

REQUIRED_DISTRO_FEATURES = "x11"

ETHEME ?= "e-wm-theme-default"
ECONFIG ?= "e-wm-config-standard"

ENLIGHTENMENT_PACKAGES = " \
	terminology \
	e-wm \
	${ECONFIG} \
	liberation-fonts \
	"

RDEPENDS_${PN} += "packagegroup-petalinux-x11 ${ENLIGHTENMENT_PACKAGES}"

RRECOMMENDS_${PN} += "${ETHEME}"

