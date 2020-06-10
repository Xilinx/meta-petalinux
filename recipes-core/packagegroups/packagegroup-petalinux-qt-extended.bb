DESCRIPTION = "PetaLinux Qt additional supported packages"

inherit packagegroup features_check

ANY_OF_DISTRO_FEATURES = "x11 fbdev wayland"

QT_EXTENDED_PACKAGES = " \
	ruby \
	packagegroup-petalinux-qt \
	qtbase-mkspecs \
	qtbase-plugins \
	qtsystems-mkspecs \
	qttranslations-qtbase \
	qttranslations-qthelp \
	qtconnectivity-mkspecs \
	qttranslations-qtconnectivity \
	qtdeclarative-mkspecs \
	qttranslations-qtdeclarative \
	qtimageformats-plugins \
	qtlocation-mkspecs \
	qtlocation-plugins \
	qttranslations-qtmultimedia \
	qtscript-mkspecs \
	qttranslations-qtscript \
	qtsensors-mkspecs \
	qtsensors-plugins \
	qtserialport-mkspecs \
	qtsvg-mkspecs \
	qtsvg-plugins \
	qtwebsockets-mkspecs \
	qttranslations-qtwebsockets \
	qtwebchannel-mkspecs \
	qtxmlpatterns-mkspecs \
	qttranslations-qtxmlpatterns \
	qtwebkit-mkspecs \
	${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'qtx11extras', '', d)} \
	qtgraphicaleffects-qmlplugins \
	"
RDEPENDS_${PN} = "${QT_EXTENDED_PACKAGES}"
