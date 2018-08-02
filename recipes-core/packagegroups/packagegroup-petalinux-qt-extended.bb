DESCRIPTION = "PetaLinux Qt additional supported packages"

inherit packagegroup distro_features_check

ANY_OF_DISTRO_FEATURES = "x11 fbdev opengl"

QT_EXTENDED_PACKAGES = " \
	ruby \
	packagegroup-petalinux-qt \
	qtbase-mkspecs \
	qtbase-plugins \
	qtsystems-mkspecs \
	qttranslations-qt \
	qttranslations-qtbase \
	qttranslations-qthelp \
	qtconnectivity-mkspecs \
	qttranslations-qtconnectivity \
	qtdeclarative-mkspecs \
	qttranslations-qmlviewer \
	qttranslations-qtdeclarative \
	qtenginio-mkspecs \
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
	qtx11extras \
	"
RDEPENDS_${PN} = "${QT_EXTENDED_PACKAGES}"
