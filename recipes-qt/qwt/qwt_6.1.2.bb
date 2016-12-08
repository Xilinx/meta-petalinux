DESCRIPTION = "Qt Widget Extension for Technical Applications"
SECTION = "libs"

# LGPLv2.1 + some exceptions
LICENSE = "QWTv1.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=dac2743472b0462ff3cfb4af42051c88"

SRC_URI = "${SOURCEFORGE_MIRROR}/qwt/qwt-${PV}.tar.bz2;name=qwt"
SRC_URI[qwt.md5sum] = "9c88db1774fa7e3045af063bbde44d7d"
SRC_URI[qwt.sha256sum] = "2b08f18d1d3970e7c3c6096d850f17aea6b54459389731d3ce715d193e243d0c"

DEPENDS = "qtbase qtsvg qttools"

RPROVIDES_${PN}-dev = "libqwt-dev"

S = "${WORKDIR}/qwt-${PV}"

require recipes-qt/qt5/qt5.inc
inherit qmake5

QT_BASE_NAME = "qt5"
QT_DIR_NAME = "/qt5"
QT_LIBINFIX = ""

do_configure_prepend() {
    sed -i -e 's:#QWT_CONFIG.*+=.*QwtExamples:QWT_CONFIG += QwtExamples:g' ${S}/qwtconfig.pri
    sed -i -e 's:/usr/local/qwt-$$QWT_VERSION:${prefix}:g' ${S}/*.pri
    sed -i -e 's:QMAKE_RPATHDIR*:#QMAKE_RPATHDIR:g' ${S}/examples/*.pri
    sed -i -e 's:QMAKE_RPATHDIR*:#QMAKE_RPATHDIR:g' ${S}/designer/*.pro
}

do_install() {
    find -name "Makefile*" | xargs sed -i "s,(INSTALL_ROOT)${STAGING_DIR_TARGET},(INSTALL_ROOT),g"
    oe_runmake -e install INSTALL_ROOT=${D}

    install -d ${D}${datadir}/doc/${PN}
    mv ${D}${prefix}/doc/* ${D}${datadir}/doc/${PN}/
    rmdir ${D}${prefix}/doc
    cd ${S}/../build/examples
    install -d ${D}/${bindir}
    cd bin${QT_LIBINFIX}/
    for i in * ; do
        cp -pPR --no-preserve=ownership ${i} ${D}/${bindir}/${i}${QT_LIBINFIX}
    done
    install -d ${D}${libdir}${QT_DIR_NAME}
    mv ${D}${prefix}/plugins ${D}${libdir}${QT_DIR_NAME}
}

PACKAGES_prepend = "${PN}-features "
FILES_${PN}-features = "${prefix}/features"
FILES_${PN}-doc += "${prefix}/doc"
FILES_${PN}-plugins += "${libdir}/${QT_BASE_NAME}/plugins/designer/*${SOLIBSDEV}"
FILES_${PN}-dbg += "${libdir}/${QT_BASE_NAME}/plugins/designer/.debug"

ARM_INSTRUCTION_SET = "arm"

EXCLUDE_FROM_WORLD = "1"
