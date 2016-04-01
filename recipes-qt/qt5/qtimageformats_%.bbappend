FILESEXTRAPATHS_prepend_zynqmp := "${THISDIR}/${PN}:"

SRC_URI_append_zynqmp += "file://0001-disable-neon-on-aarch64-builds.patch"

