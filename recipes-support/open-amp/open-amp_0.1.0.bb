SUMMARY = "Libopen_amp : Libmetal implements an abstraction layer across user-space Linux, baremetal, and RTOS environments"

HOMEPAGE = "https://github.com/OpenAMP/open-amp/"

SECTION = "libs"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b30cbe0b980e98bfd9759b1e6ba3d107"

SRCREV ?= "${AUTOREV}"
SRC_URI = "git://gitenterprise.xilinx.com/OpenAMP/open-amp.git;protocol=https;branch=wendy/wip-0801"

S = "${WORKDIR}/git"
DEPENDS = "libmetal"
inherit pkgconfig cmake

EXTRA_OECMAKE = "-DLIB_INSTALL_DIR=${libdir} -DLIBEXEC_INSTALL_DIR=${libexecdir} -DMACHINE=${SOC_FAMILY}"
