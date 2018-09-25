DESCRIPTION = "PetaLinux Qt supported packages"

inherit packagegroup distro_features_check

ANY_OF_DISTRO_FEATURES = "x11 fbdev wayland"

QT_PACKAGES = " \
	qtbase \
	qtbase-plugins \
	qtbase-examples \
	qtquick1 \
	qtquick1-plugins \
	qtquickcontrols-qmlplugins \
	qtcharts \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'qtwayland', '', d)} \
	"
RDEPENDS_${PN} = "${QT_PACKAGES}"
