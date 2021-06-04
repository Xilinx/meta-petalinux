FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://0002-no-icc.patch"

pkg_postinst_ontarget_${PN}() {
  ${bindir}/dot -c
}
