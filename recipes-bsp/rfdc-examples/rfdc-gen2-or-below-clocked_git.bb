SUMMARY = "Simple rfdc-gen2-or-below-clocked application"

require rfdc-examples.inc

do_compile (){
    make all BOARD_FLAG=${FLAG} OUTS=${B}/rfdc-gen2-or-below-clocked RFDC_OBJS=xrfdc_gen2_or_below_clocked_example.o
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/rfdc-gen2-or-below-clocked ${D}${bindir}
}
