REPO ?= "git://github.com/Xilinx/runx.git"
SRCREV_runx ?= "7acc524653e1a85e4ce14a1851e6f2941498e77b"
BRANCH ?= "xilinx/release-2020.2"


do_install() {

    install -d ${D}${datadir}/runX
    install -m 755 ${B}/src/import/gobuild/serial_fd_handler ${D}${datadir}/runX/
}

