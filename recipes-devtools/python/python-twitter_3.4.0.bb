SUMMARY = "Twitter for Python"
DESCRIPTION = "Python module to support twitter API"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://PKG-INFO;md5=7da76c4acd99d62073eb09aa571fe45a"

SRC_URI[md5sum] = "52e1210bfd8087e25a9536f76b0ae60b"
SRC_URI[sha256sum] = "6f34110510eca609cdc51934ce927f58164dba12453517662fe58fbbd7d0b2e3"

PYPI_PACKAGE = "tweepy"
inherit pypi setuptools

SRC_URI += "file://setup.py"

RDEPENDS_${PN} += "\
	${PYTHON_PN}-pip \
	${PYTHON_PN}-pysocks \
	${PYTHON_PN}-requests \
	${PYTHON_PN}-six \
	"

do_configure_prepend() {
    # upstream setup.py overcomplicated, use ours
    install -m 0644 ${WORKDIR}/setup.py ${S}
}
