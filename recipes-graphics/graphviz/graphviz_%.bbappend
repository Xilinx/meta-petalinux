FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://0002-no-icc.patch"

pkg_postinst_ontarget:${PN}() {
  ${bindir}/dot -c
}
