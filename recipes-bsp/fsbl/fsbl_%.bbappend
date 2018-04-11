STAGING_RFDC_DIR = "${TMPDIR}/work-shared/${MACHINE}/rfdc-source"

addtask shared_workdir after do_compile before do_install
do_shared_workdir() {
    :
}

do_shared_workdir_zynqmpdr() {
    install -d ${STAGING_RFDC_DIR}
    install -m 0644 ${XSCTH_WS}/${XSCTH_PROJ}_bsp/${XSCTH_PROC}/libsrc/rfdc*/src/xrfdc_g.c ${STAGING_RFDC_DIR}
    install -m 0644 ${XSCTH_WS}/${XSCTH_PROJ}_bsp/${XSCTH_PROC}/include/xparameters.h ${STAGING_RFDC_DIR}
    install -m 0644 ${XSCTH_WS}/${XSCTH_PROJ}_bsp/${XSCTH_PROC}/libsrc/standalone*/src/xparameters_ps.h ${STAGING_RFDC_DIR}
}

addtask shared_workdir_setscene
do_shared_workdir_setscene () {
     exit 1
}

