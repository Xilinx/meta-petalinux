DESCRIPTION = "PetaLinux Qt supported Packages"

inherit packagegroup distro_features_check
ANY_OF_DISTRO_FEATURES = "x11 fbdev opengl"

QT_PACKAGES = " \
        ruby \
	cpufrequtils \
	qtbase-dev \
	qtbase-mkspecs \
	qtbase-plugins \
	qtsystems-mkspecs \
	qtbase-staticdev \
	qttranslations-qt \
	qttranslations-qtbase \
	qttranslations-qtconfig \
	qttranslations-qthelp \
	qtconnectivity-mkspecs \
	qttranslations-qtconnectivity \
	qtdeclarative-mkspecs \
	qtdeclarative-staticdev \
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
	qtbase-examples \
	qtwebkit-mkspecs \
	qtcharts \
	"
RDEPENDS_${PN} += "${QT_PACKAGES}"
