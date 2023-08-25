do_install:append() {
    if [ -e ${D}/bin/ping ]; then
        chmod u+rxs ${D}/bin/ping
    elif [ -e ${D}/${bindir}/ping ]; then
        chmod u+rxs ${D}/${bindir}/ping
    fi
}
