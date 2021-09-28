SUMMARY = "Simple rfdc-mts application"

require rfdc-examples.inc

do_compile (){
    make all BOARD_FLAG=${FLAG} OUTS=${B}/rfdc-mts RFDC_OBJS=xrfdc_mts_example.o
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/rfdc-mts ${D}${bindir}
}
