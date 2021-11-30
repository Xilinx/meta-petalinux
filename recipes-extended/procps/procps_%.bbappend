do_configure:append() {
    echo "kernel.printk = 4 4 1 7" >> ${WORKDIR}/sysctl.conf
}
