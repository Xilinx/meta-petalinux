REPO ?= "git://github.com/Xilinx/runx.git;protocol=https;"
SRCREV_runx ?= "7acc524653e1a85e4ce14a1851e6f2941498e77b"
BRANCH ?= "xilinx/release-2020.2"


SRC_URI_remove = " \
	 file://0001-make-kernel-cross-compilation-tweaks.patch \
	 file://0001-make-initrd-cross-install-tweaks.patch \
"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI_append = " \
	file://make-kernel-cross-compilation-tweaks.patch \
	file://make-initrd-cross-install-tweaks.patch \	
"

do_compile() {

# we'll need this for the initrd later, so lets error if it isn't what
    # we expect (statically linked)
    file ${STAGING_DIR_HOST}/bin/busybox.nosuid

    # prep steps to short circuit some of make-kernel's fetching and
    # building.
    mkdir -p ${S}/kernel/build
    mkdir -p ${S}/kernel/src
    cp ${DL_DIR}/linux-4.15.tar.xz ${S}/kernel/build/

    # In the future, we might want to link the extracted kernel source (if
    # we move patches to recipe space, but for now, we need make-kernel to
    # extract a copy and possibly patch it.
    # ln -sf ${WORKDIR}/linux-4.15 ${S}/kernel/src/

    # build the kernel
    echo "[INFO]: runx: building the kernel"

    export KERNEL_CC="${KERNEL_CC}"
    export KERNEL_LD="${KERNEL_LD}"
    export ARCH="${ARCH}"
    export HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}"
    export HOSTCPP="${BUILD_CPP}"
    export CROSS_COMPILE="${CROSS_COMPILE}"
    export build_vars="HOSTCC='$HOSTCC' STRIP='$STRIP' OBJCOPY='$OBJCOPY' ARCH=$ARCH CC='$KERNEL_CC' LD='$KERNEL_LD'"

    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE

    # We want make-kernel, to have the following build lines:
    #    make O=$kernel_builddir HOSTCC="${HOSTCC}" ARCH=$ARCH oldconfig
    #    make -j4 O=$kernel_builddir HOSTCC="${HOSTCC}" STRIP="$STRIP" OBJCOPY="$OBJCOPY" ARCH=$ARCH CC="$KERNEL_CC" LD="$KERNEL_LD" $image
    ${S}/kernel/make-kernel

    # construct the initrd
    echo "[INFO]: runx: constructing the initrd"

    cp ${STAGING_DIR_HOST}/bin/busybox.nosuid ${WORKDIR}/busybox
    export QEMU_USER=`which qemu-${HOST_ARCH}`
    export BUSYBOX="${WORKDIR}/busybox"
    export CROSS_COMPILE="t"
    ${S}/initrd/make-initrd
}

do_install() {
    install -d ${D}${bindir}
    install -m 755 ${S}/runX ${D}${bindir}

    install -d ${D}${datadir}/runX
    install -m 755 ${S}/kernel/out/kernel ${D}/${datadir}/runX
    install -m 755 ${S}/initrd/out/initrd ${D}/${datadir}/runX
    install -m 755 ${S}/files/start ${D}/${datadir}/runX
    install -m 755 ${S}/files/state ${D}/${datadir}/runX
    install -m 755 ${S}/files/delete ${D}/${datadir}/runX
    install -m 755 ${S}/files/serial_start ${D}/${datadir}/runX
    install -m 755 ${S}/files/create ${D}/${datadir}/runX

}

