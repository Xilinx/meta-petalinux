SUMMARY = "Simple rfdc-gen3 application"

require rfdc-examples.inc

do_compile (){
    make all BOARD_FLAG=${FLAG} OUTS=${B}/rfdc-gen3-clocked RFDC_OBJS=xrfdc_gen3_clocked_example.o
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/rfdc-gen3-clocked ${D}${bindir}
}
