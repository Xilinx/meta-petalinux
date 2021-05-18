DESCRIPTION = "PetaLinux Qt supported packages"

# Workaround for DISTRO_FEATURES wayland only set on 64-bit ARM machines
PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup features_check

ANY_OF_DISTRO_FEATURES = "x11 fbdev wayland"

QT_PACKAGES = " \
	qtbase \
	qtbase-plugins \
	qtbase-examples \
	qtquickcontrols-qmlplugins \
	qtcharts \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'qtwayland', '', d)} \
	"
RDEPENDS_${PN} = "${QT_PACKAGES}"
