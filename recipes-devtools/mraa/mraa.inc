SUMMARY = "Low Level Skeleton Library for Communication on Intel platforms"
SECTION = "libs"
AUTHOR = "Brendan Le Foll, Tom Ingleby"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=66493d54e65bfc12c7983ff2e884f37f"

S = "${WORKDIR}/git"

inherit distutils-base pkgconfig python-dir cmake

DEPENDS += "nodejs-native"

EXTRA_OECMAKE_append = " -DINSTALLTOOLS:BOOL=ON -DFIRMATA=ON \
                         -DPYTHON2_PACKAGES_PATH:FILEPATH=../${PYTHON_SITEPACKAGES_DIR} \
                         -DBASE_LIB_INSTALL_DIR=${base_libdir} -DCMAKE_SKIP_RPATH=ON"

FILES_${PN}-doc += "${datadir}/mraa/examples/"

# Prepend mraa-utils to make sure bindir ends up in there
PACKAGES =+ "${PN}-utils "

DEPENDS += " json-c"

FILES_${PN}-utils = "${bindir}/ \
                    "

# override this in local.conf to get a subset of bindings.
# BINDINGS_pn-mraa="python"
# will result in only the python bindings being built/packaged.
BINDINGS ?= "python nodejs"

PACKAGECONFIG ??= "${@bb.utils.contains('PACKAGES', 'node-${PN}', 'nodejs', '', d)} \
 ${@bb.utils.contains('PACKAGES', 'python-${PN}', 'python', '', d)}"

PACKAGECONFIG[python] = "-DBUILDSWIGPYTHON=ON, -DBUILDSWIGPYTHON=OFF, swig-native python,"
PACKAGECONFIG[nodejs] = "-DBUILDSWIGNODE=ON, -DBUILDSWIGNODE=OFF, swig-native nodejs,"

do_compile_prepend () {
  # when yocto builds in ${D} it does not have access to ../git/.git so git
  # describe --tags fails. In order not to tag our version as dirty we use this
  # trick
  sed -i 's/-dirty//' src/version.c
}

### Python ###

# python-mraa package containing Python bindings
FILES_python-${PN} = "${PYTHON_SITEPACKAGES_DIR}/ \
                      ${datadir}/mraa/examples/python/ \
                      ${prefix}/src/debug/${BPN}/${PV}-${PR}/build/src/python/ \
                     "
RDEPENDS_python-${PN} += "python"
INSANE_SKIP_python-${PN} = "debug-files"


### Node ###

# node-mraa package containing Nodejs bindings
FILES_node-${PN} = "${prefix}/lib/node_modules/ \
                    ${datadir}/mraa/examples/javascript/ \
                   "
RDEPENDS_node-${PN} += "nodejs"
INSANE_SKIP_node-${PN} = "debug-files"

### Include desired language bindings ###
PACKAGES =+ "${@bb.utils.contains('BINDINGS', 'nodejs', 'node-${PN}', '', d)}"
PACKAGES =+ "${@bb.utils.contains('BINDINGS', 'python', 'python-${PN}', '', d)}"
