FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " \
    file://0001-generate-pkg-config-file-for-node-and-install.patch \
    file://0002-generate-pkg-config-file-for-node-and-install.patch \
    "

pkg_postinst_${PN} () {
    sed -e '/^PATH=/aNODE_PATH=\/usr\/lib\/node_modules\/' \
        -e 's/\(^export\)\(.*\)/\1 NODE_PATH\2/' \
        -i $D/etc/profile
}

pkg_prerm_${PN} () {
    sed -e '/^NODE_PATH.*$/d' \
        -e 's/\(^export\)\(.*\)\(\<NODE_PATH\>\s\)\(.*\)/\1\2\4/' \
        -i $D/etc/profile
}

FILES_${PN}-dev += "/usr/lib64/pkgconfig/node.pc"
