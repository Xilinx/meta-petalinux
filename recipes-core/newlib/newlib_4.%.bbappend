# Fix for multilib newlib installations
do_install:prepend:xilinx-standalone() {
        mkdir -p $(dirname ${D}${libdir})
        mkdir -p $(dirname ${D}${includedir})
}

