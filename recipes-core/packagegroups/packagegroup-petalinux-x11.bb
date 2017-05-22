DESCRIPTION = "PetaLinux X11 related Packages"
LICENSE = "NONE"

inherit packagegroup distro_features_check
REQUIRED_DISTRO_FEATURES = "x11"

X11_PACKAGES = " \
	packagegroup-core-x11-base \
	xauth \
	xhost \
	xset \
	xtscal \
	xcursor-transparent-theme \
	xinit \
	xinput \
	xinput-calibrator \
	xkbcomp \
	xkeyboard-config \
	xkeyboard-config-locale-en-gb \
	xmodmap \
	xrandr \
	xserver-nodm-init \
	"

RDEPENDS_${PN} += "${X11_PACKAGES}"
