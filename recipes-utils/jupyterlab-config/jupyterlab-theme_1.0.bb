SUMMARY = "Jupyter-lab dark theme override"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://overrides.json"

RDEPENDS_${PN} = "python3-jupyterlab"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${datadir}/jupyter/lab/settings
	install -m 0644 ${WORKDIR}/overrides.json ${D}${datadir}/jupyter/lab/settings
}

FILES_${PN} += "${datadir}/jupyter/lab/settings"
