FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://0001-configure.ac-Remove-icc-build-path.patch"

pkg_postinst_ontarget:${PN}() {
  ${bindir}/dot -c
}
