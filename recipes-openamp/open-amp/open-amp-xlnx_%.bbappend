# Disable configuration actions
OPENAMP_CFG_HEADER:xilinx-standalone = ""

# Disable other actions
do_gen_linker:xilinx-standalone() {
    :
}

do_compile_rpu:xilinx-standalone() {
    :
}

# Create dummy files
do_install_rpu:xilinx-standalone() {
    install -d ${D}/${bindir}
    touch ${D}/${bindir}/rpmsg-echo.out
    touch ${D}/${bindir}/matrix_multiplyd.out
    touch ${D}/${bindir}/rpc_demo.out

    touch ${D}/${bindir}/rpmsg-echo.elf
    touch ${D}/${bindir}/matrix_multiplyd.elf
    touch ${D}/${bindir}/rpc_demo.elf
}

do_deploy_rpu:xilinx-standalone() {
    install -d ${DEPLOYDIR}/
    install -Dm 0644 ${D}/${bindir}/*.out ${DEPLOYDIR}/
    install -Dm 0644 ${D}/${bindir}/*.elf ${DEPLOYDIR}/

    touch ${DEPLOYDIR}/rpmsg-echo.bin
    touch ${DEPLOYDIR}/matrix_multiplyd.bin
    touch ${DEPLOYDIR}/rpc_demo.bin
}

