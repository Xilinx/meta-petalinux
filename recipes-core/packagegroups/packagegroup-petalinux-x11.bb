DESCRIPTION = "PetaLinux X11 related packages"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "x11"

X11_PACKAGES = " \
	packagegroup-core-x11 \
	xclock \
	xcursor-transparent-theme \
	xeyes \
	xinit \
	xinput \
	xkbcomp \
	xkeyboard-config \
	xkeyboard-config-locale-en-gb \
	dbus \
	liberation-fonts \
	"

RDEPENDS:${PN} = "${X11_PACKAGES}"
