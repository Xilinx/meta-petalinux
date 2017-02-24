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

MATCHBOX_PACKAGES = " \
       matchbox-config-gtk \
       matchbox-desktop \
       matchbox-keyboard \
       matchbox-keyboard-applet \
       matchbox-panel-2 \
       matchbox-session \
       matchbox-terminal \
       matchbox-theme-sato \
       matchbox-session-sato \
       matchbox-wm \
       settings-daemon \
       "

RDEPENDS_${PN} += "${X11_PACKAGES} ${MATCHBOX_PACKAGES}"
