SUMMARY = "Symlinks for python version files"
LICENSE = "MIT"
SECTION = "devel/python"

do_configure[noexec] = '1'
do_compile[noexec] = '1'

INHIBIT_DEFAULT_DEPS = '1'

RDEPENDS_${PN} = 'python3-core'

do_install() {
	mkdir -p ${D}${bindir}
	# Install symlinks for utilities that try to call specific versions
	ln -s python3.7 ${D}${bindir}/python3.0
	ln -s python3.7 ${D}${bindir}/python3.1
	ln -s python3.7 ${D}${bindir}/python3.2
	ln -s python3.7 ${D}${bindir}/python3.3
	ln -s python3.7 ${D}${bindir}/python3.4
	ln -s python3.7 ${D}${bindir}/python3.5
	ln -s python3.7 ${D}${bindir}/python3.6
}

BBCLASSEXTEND = "nativesdk"
