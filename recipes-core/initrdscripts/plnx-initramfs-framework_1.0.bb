require ${COREBASE}/meta/recipes-core/initrdscripts/initramfs-framework_1.0.bb

FILESEXTRAPATHS:append := ":${COREBASE}/meta/recipes-core/initrdscripts/initramfs-framework"

PACKAGES = " \
    ${PN}-base \
    plnx-initramfs-module-exec \
    plnx-initramfs-module-mdev \
    plnx-initramfs-module-udev \
    plnx-initramfs-module-e2fs \
    plnx-initramfs-module-nfsrootfs \
    plnx-initramfs-module-rootfs \
    plnx-initramfs-module-debug \
    plnx-initramfs-module-lvm \
    plnx-initramfs-module-overlayroot \
    plnx-initramfs-module-udhcpc \
	plnx-initramfs-module-scripts \
	plnx-initramfs-module-searche2fs \
"

PROVIDES += "initramfs-framework"

SRC_URI += " \
	file://udhcpc \
	file://searche2fs \
	file://functions \
	"


do_install() {
    install -d ${D}/init.d
    install -d ${D}/scripts

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

    # searche2fs
    install -m 0755 ${WORKDIR}/searche2fs ${D}/init.d/92-searche2fs

    # debug
    install -m 0755 ${WORKDIR}/debug ${D}/init.d/00-debug

    # lvm
    install -m 0755 ${WORKDIR}/lvm ${D}/init.d/09-lvm

    # scripts
    install -m 0755 ${WORKDIR}/functions ${D}/scripts/functions

    # Create device nodes expected by some kernels in initramfs
    # before even executing /init.
    install -d ${D}/dev
    mknod -m 622 ${D}/dev/console c 5 1
}

RRECOMMENDS:${PN}-base = "plnx-initramfs-module-rootfs"

FILES:plnx-initramfs-module-e2fs = "/init.d/91-e2fs"
RDEPENDS:plnx-initramfs-module-e2fs += "plnx-initramfs-module-scripts"

SUMMARY:plnx-initramfs-module-udhcpc = "Enable udhcpc"
RDEPENDS:plnx-initramfs-module-udhcpc = "${PN}-base"
FILES:plnx-initramfs-module-udhcpc = "/init.d/01-udhcpc"

SUMMARY:plnx-initramfs-module-searche2fs = "search for the ext partitions available and mounts it"
RDEPENDS:plnx-initramfs-module-searche2fs = "${PN}-base plnx-initramfs-module-scripts"
FILES:plnx-initramfs-module-searche2fs = "/init.d/92-searche2fs"

SUMMARY:plnx-initramfs-module-scripts = "scripts for initramfs"
FILES:plnx-initramfs-module-scripts = "/scripts/functions"

SUMMARY:plnx-initramfs-module-exec = "${SUMMARY:initramfs-module-exec}"
RDEPENDS:plnx-initramfs-module-exec = "${RDEPENDS:initramfs-module-exec}"
FILES:plnx-initramfs-module-exec = "${FILES:initramfs-module-exec}"

SUMMARY:plnx-initramfs-module-mdev = "${SUMMARY:initramfs-module-mdev}"
RDEPENDS:plnx-initramfs-module-mdev = "${RDEPENDS:initramfs-module-mdev}"
FILES:plnx-initramfs-module-mdev = "${FILES:initramfs-module-mdev}"

SUMMARY:plnx-initramfs-module-udev = "${SUMMARY:initramfs-module-udev}"
RDEPENDS:plnx-initramfs-module-udev = "${RDEPENDS:initramfs-module-udev}"
FILES:plnx-initramfs-module-udev = "${FILES:initramfs-module-udev}"

SUMMARY:plnx-initramfs-module-nfsrootfs = "${SUMMARY:initramfs-module-nfsrootfs}"
RDEPENDS:plnx-initramfs-module-nfsrootfs = "${RDEPENDS:initramfs-module-nfsrootfs}"
FILES:plnx-initramfs-module-nfsrootfs = "${FILES:initramfs-module-nfsrootfs}"

SUMMARY:plnx-initramfs-module-rootfs = "${SUMMARY:initramfs-module-rootfs}"
RDEPENDS:plnx-initramfs-module-rootfs = "${RDEPENDS:initramfs-module-rootfs}"
FILES:plnx-initramfs-module-rootfs = "${FILES:initramfs-module-rootfs}"

SUMMARY:plnx-initramfs-module-debug = "${SUMMARY:initramfs-module-debug}"
RDEPENDS:plnx-initramfs-module-debug = "${RDEPENDS:initramfs-module-debug}"
FILES:plnx-initramfs-module-debug = "${FILES:initramfs-module-debug}"

SUMMARY:plnx-initramfs-module-lvm = "${SUMMARY:initramfs-module-lvm}"
RDEPENDS:plnx-initramfs-module-lvm = "${RDEPENDS:initramfs-module-lvm}"
FILES:plnx-initramfs-module-lvm = "${FILES:initramfs-module-lvm}"

SUMMARY:plnx-initramfs-module-overlayroot = "${SUMMARY:initramfs-module-overlayroot}"
RDEPENDS:plnx-initramfs-module-overlayroot = "${PN}-base plnx-initramfs-module-rootfs"
FILES:plnx-initramfs-module-overlayroot = "${FILES:initramfs-module-overlayroot}"
