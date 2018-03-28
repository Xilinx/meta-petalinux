DESCRIPTION = "PetaLinux Matchbox related packages"

inherit packagegroup distro_features_check

REQUIRED_DISTRO_FEATURES = "x11"

FILEMANAGER ?= "pcmanfm"

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
        adwaita-icon-theme \
	l3afpad \
	${FILEMANAGER} \
	"

RDEPENDS_${PN} = "packagegroup-petalinux-x11 ${MATCHBOX_PACKAGES}"
