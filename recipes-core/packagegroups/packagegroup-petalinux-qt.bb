DESCRIPTION = "PetaLinux Qt supported Packages"
LICENSE = "NONE"

inherit packagegroup distro_features_check
ANY_OF_DISTRO_FEATURES = "x11 fbdev opengl"

QT_PACKAGES = " \
        ruby \
	cpufrequtils \
	qtbase-dev \
	qtbase-mkspecs \
	qtbase-plugins \
	qtsystems-dev \
	qtsystems-mkspecs \
	qtbase-staticdev \
	qttranslations-qt \
	qttranslations-qtbase \
	qttranslations-qtconfig \
	qttranslations-qthelp \
	qtconnectivity-dev \
	qtconnectivity-mkspecs \
	qttranslations-qtconnectivity \
	qtdeclarative-dev \
	qtdeclarative-mkspecs \
	qtdeclarative-plugins \
	qtdeclarative-staticdev \
	qttranslations-qmlviewer \
	qttranslations-qtdeclarative \
	qtenginio-dev \
	qtenginio-mkspecs \
	qtimageformats-dev \
	qtimageformats-plugins \
	qtlocation-dev \
	qtlocation-mkspecs \
	qtlocation-plugins \
	qttranslations-qtmultimedia \
	qtscript-dev \
	qtscript-mkspecs \
	qttranslations-qtscript \
	qtsensors-dev \
	qtsensors-mkspecs \
	qtsensors-plugins \
	qtserialport-dev \
	qtserialport-mkspecs \
	qtsvg-dev \
	qtsvg-mkspecs \
	qtsvg-plugins \
	qttools-dev \
	qttools-mkspecs \
	qttools-staticdev \
	qttools-tools \
	qtwebsockets-dev \
	qtwebsockets-mkspecs \
	qttranslations-qtwebsockets \
	qtwebchannel-dev \
	qtwebchannel-mkspecs \
	qtxmlpatterns-dev \
	qtxmlpatterns-mkspecs \
	qttranslations-qtxmlpatterns \
	qtbase-examples \
	qtquick1-dev \
	qtquick1-mkspecs \
	qtquick1-plugins \
	qttranslations-qtquick1 \
	qtwebkit-dev \
	qtwebkit-mkspecs \
	qtquickcontrols-qmlplugins \
	qttools-plugins \
	qtcharts \
	"
RDEPENDS_${PN} += "${QT_PACKAGES}"
