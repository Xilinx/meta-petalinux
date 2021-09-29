do_install:append() {
    ln -sf make ${D}${bindir}/gmake
}
