DESCRIPTION = "PetaLinux X11 related packages"

inherit packagegroup distro_features_check

REQUIRED_DISTRO_FEATURES = "x11"

X11_PACKAGES = " \
	packagegroup-core-x11 \
	xtscal \
	xcursor-transparent-theme \
	xinit \
	xinput \
	xkbcomp \
	xkeyboard-config \
	xkeyboard-config-locale-en-gb \
	dbus \
	liberation-fonts \
	"

RDEPENDS_${PN} = "${X11_PACKAGES}"
