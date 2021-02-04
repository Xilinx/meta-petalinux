FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://e2fs \
	file://udhcpc"

PACKAGES += "initramfs-module-udhcpc"

do_install() {
    install -d ${D}/init.d

    # base
    install -m 0755 ${WORKDIR}/init ${D}/init
    install -m 0755 ${WORKDIR}/nfsrootfs ${D}/init.d/85-nfsrootfs
    install -m 0755 ${WORKDIR}/rootfs ${D}/init.d/90-rootfs
    install -m 0755 ${WORKDIR}/finish ${D}/init.d/99-finish

	# exec
    install -m 0755 ${WORKDIR}/exec ${D}/init.d/89-exec

    # mdev
    install -m 0755 ${WORKDIR}/mdev ${D}/init.d/01-mdev

    # udev
    install -m 0755 ${WORKDIR}/udev ${D}/init.d/01-udev

    # e2fs
    install -m 0755 ${WORKDIR}/e2fs ${D}/init.d/91-e2fs

    # udhcpc
    install -m 0755 ${WORKDIR}/udhcpc ${D}/init.d/01-udhcpc

    # debug
    install -m 0755 ${WORKDIR}/debug ${D}/init.d/00-debug

    # lvm
    install -m 0755 ${WORKDIR}/lvm ${D}/init.d/09-lvm

    # Create device nodes expected by some kernels in initramfs
    # before even executing /init.
    install -d ${D}/dev
    mknod -m 622 ${D}/dev/console c 5 1
}

FILES_initramfs-module-e2fs = "/init.d/91-e2fs"

SUMMARY_initramfs-module-udhcpc = "Enable udhcpc"
RDEPENDS_initramfs-module-udhcpc = "${PN}-base"
FILES_initramfs-module-udhcpc = "/init.d/01-udhcpc"
