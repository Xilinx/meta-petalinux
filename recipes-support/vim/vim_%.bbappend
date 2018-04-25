PACKAGECONFIG_append = " gtkgui"

do_install_append() {
    install -m 0755 ${S}/vim ${D}/${bindir}/gvim
}

ALTERNATIVE_TARGET = "${bindir}/gvim"
