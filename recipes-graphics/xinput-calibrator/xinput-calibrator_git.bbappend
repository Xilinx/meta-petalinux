do_install:append() {
    # Do not install the boot time auto launcher
    rm -rf ${D}${sysconfdir}/xdg/autostart
}
