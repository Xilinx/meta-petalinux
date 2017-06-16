SUMMARY = "Sensor/Actuator repository for Mraa"
SECTION = "libs"
AUTHOR = "Brendan Le Foll, Tom Ingleby, Yevgeniy Kiveisha"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=66493d54e65bfc12c7983ff2e884f37f"

DEPENDS = "libjpeg-turbo mraa"

SRC_URI = "git://github.com/intel-iot-devkit/upm.git;protocol=git;tag=v${PV}"

S = "${WORKDIR}/git"

inherit distutils-base pkgconfig python-dir cmake

CFLAGS_append_edison = " -msse3 -mfpmath=sse"

FILES_${PN}-doc += "${datadir}/upm/examples/"
RDEPENDS_${PN} += "mraa"

# override this in local.conf to get a subset of bindings.
# BINDINGS_pn-upm="python"
# will result in only the python bindings being built/packaged.

BINDINGS ?= "python nodejs"

PACKAGECONFIG ??= "${@bb.utils.contains('PACKAGES', 'node-${PN}', 'nodejs', '', d)} \
 ${@bb.utils.contains('PACKAGES', 'python-${PN}', 'python', '', d)}"

PACKAGECONFIG[python] = "-DBUILDSWIGPYTHON=ON, -DBUILDSWIGPYTHON=OFF, swig-native ${PYTHON_PN},"
PACKAGECONFIG[nodejs] = "-DBUILDSWIGNODE=ON, -DBUILDSWIGNODE=OFF, swig-native nodejs,"

### Python ###

# Python dependency in PYTHON_PN (from poky/meta/classes/python-dir.bbclass)
# Possible values for PYTHON_PN: "python" or "python3"

# python-upm package containing Python bindings
FILES_${PYTHON_PN}-${PN} = "${PYTHON_SITEPACKAGES_DIR} \
                       ${datadir}/${BPN}/examples/python/ \
                       ${prefix}/src/debug/${BPN}/${PV}-${PR}/build/src/*/pyupm_* \
                      "
RDEPENDS_${PYTHON_PN}-${PN} += "${PYTHON_PN} mraa"
INSANE_SKIP_${PYTHON_PN}-${PN} = "debug-files"


### Node ###

# node-upm package containing Nodejs bindings
FILES_node-${PN} = "${prefix}/lib/node_modules/ \
                    ${datadir}/${BPN}/examples/javascript/ \
                   "
RDEPENDS_node-${PN} += "nodejs mraa"
INSANE_SKIP_node-${PN} = "debug-files"

### Include desired language bindings ###
PACKAGES =+ "${@bb.utils.contains('BINDINGS', 'nodejs', 'node-${PN}', '', d)}"
PACKAGES =+ "${@bb.utils.contains('BINDINGS', 'python', 'python-${PN}', '', d)}"
