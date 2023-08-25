HOMEPAGE = "https://github.com/lf-edge/runx"
SUMMARY = "runx stuff"
DESCRIPTION = "Xen Runtime for OCI"

SRCREV_runx ?= "0c7edb3453398d7a0c594ce026c9c1e93c2541cc"
REPO ?= "git://github.com/Xilinx/runx.git;protocol=https;"
BRANCH ?= "xlnx_rebase_1.1"
REPO_BRANCH ??= "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH', True) != '']}" 

KERNEL_SRC_VER="linux-5.10.74"
KERNEL_URL_VER="v5.x"

SRC_URI = "\
	  ${REPO};${REPO_BRANCH};name=runx \
          https://www.kernel.org/pub/linux/kernel/${KERNEL_URL_VER}/${KERNEL_SRC_VER}.tar.xz;destsuffix=git/kernel/build \
          file://0001-make-kernel-cross-compilation-tweaks.patch \
          file://0001-make-initrd-allow-externally-provided-busybox.patch \
	  "

SRC_URI[md5sum] = "4855b6e915d44586d7aacc3372e2cd52"
SRC_URI[sha256sum] = "5755a6487018399812238205aba73a2693b0f9f3cd73d7cf1ce4d5436c3de1b0"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=945fc9aa694796a6337395cc291ddd8c"

S = "${WORKDIR}/git"
PV = "v1.0-git${SRCREV_runx}"

inherit features_check
REQUIRED_DISTRO_FEATURES = "vmsep"

inherit pkgconfig
# for the kernel build
inherit kernel-arch

# we have a busybox bbappend that makes /bin available to the
# sysroot, and hence gets us the target binary that we need
DEPENDS = "busybox-initrd go-build"
DEPENDS += "resolvconf"

# for the kernel build phase
DEPENDS += "openssl-native coreutils-native util-linux-native xz-native bc-native"
DEPENDS += "elfutils-native"
DEPENDS += "qemu-native bison-native"

RDEPENDS:${PN} += " jq bash"
RDEPENDS:${PN} += " xen-tools-xl go-build socat daemonize"
RDEPENDS:${PN} += " ca-certificates qemu qemu-keymaps"

RUNX_USE_INTERNAL_BUSYBOX ?= ""

# We depend on the kernel, but we don't actually change for the same kernel version
# Avoid the package rebuilding when re-used on a different machine
STAGING_KERNEL_DIR[vardepsexclude] += "MACHINE"
STAGING_KERNEL_BUILDDIR[vardepsexclude] += "MACHINE"

do_compile() {
    # we'll need this for the initrd later, so lets error if it isn't what
    # we expect (statically linked)
    if [ -z "${RUNX_USE_INTERNAL_BUSYBOX}" ]; then
        if [ ! -e ${STAGING_DIR_HOST}/bin/busybox.nosuid ] ; then
            bberror "busybox.nosuid is required.  Set RUNX_USE_INTERNAL_BUSYBOX='1' to build it"
        else
            file ${STAGING_DIR_HOST}/bin/busybox.nosuid
        fi
    fi
    
    # prep steps to short circuit some of make-kernel's fetching and
    # building.
    mkdir -p ${S}/kernel/build
    mkdir -p ${S}/kernel/src
    cp ${DL_DIR}/${KERNEL_SRC_VER}.tar.xz ${S}/kernel/build/

    # In the future, we might want to link the extracted kernel source (if
    # we move patches to recipe space, but for now, we need make-kernel to
    # extract a copy and possibly patch it.
    # ln -sf ${WORKDIR}/${KERNEL_SRC_VER} ${S}/kernel/src/

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
    bbnote "runx: constructing the initrd"
    if [ -z "${RUNX_USE_INTERNAL_BUSYBOX}" ]; then
        bbnote "runx: using external busybox"
        cp ${STAGING_DIR_HOST}/bin/busybox.nosuid ${WORKDIR}/busybox
        export QEMU_USER="`which qemu-${HOST_ARCH}` -L ${STAGING_BASELIBDIR}/.."
        export BUSYBOX="${WORKDIR}/busybox"
        export busybox="${WORKDIR}/busybox"
        export CROSS_COMPILE="${TARGET_PREFIX}"
    else
        bbnote "runx: using internal busybox"
        export CC="${CC}"
        export LD="${LD}"
        export CFLAGS="${HOST_CC_ARCH}${TOOLCHAIN_OPTIONS} ${CFLAGS}"
        export LDFLAGS="${TOOLCHAIN_OPTIONS} ${HOST_LD_ARCH} ${LDFLAGS}"
        export HOSTCFLAGS="${BUILD_CFLAGS} ${BUILD_LDFLAGS}"
        export CROSS_COMPILE="${TARGET_PREFIX}"
    fi
    ${S}/initrd/make-initrd
}

do_install() {
    install -d ${D}${bindir}
    install -m 755 ${S}/runX ${D}${bindir}
    
    install -d ${D}${datadir}/runX
    install -m 755 ${S}/kernel/out/kernel ${D}/${datadir}/runX
    install -m 755 ${S}/initrd/out/initrd ${D}/${datadir}/runX
    install -m 755 ${S}/files/start ${D}/${datadir}/runX
    install -m 755 ${S}/files/create ${D}/${datadir}/runX
    install -m 755 ${S}/files/state ${D}/${datadir}/runX
    install -m 755 ${S}/files/delete ${D}/${datadir}/runX
    install -m 755 ${S}/files/serial_start ${D}/${datadir}/runX


}

deltask compile_ptest_base

FILES:${PN} += "${bindir}/* ${datadir}/runX/*"

INHIBIT_PACKAGE_STRIP = "1"
INSANE_SKIP:${PN} += "ldflags already-stripped"
