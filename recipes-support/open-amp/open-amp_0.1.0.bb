SUMMARY = "Libopen_amp : Libmetal implements an abstraction layer across user-space Linux, baremetal, and RTOS environments"

HOMEPAGE = "https://github.com/OpenAMP/open-amp/"

SECTION = "libs"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b30cbe0b980e98bfd9759b1e6ba3d107"

# Initial tag of open-amp xilinx-v2016.3-rc1
SRCREV ?= "2d158e856c0c52b18a4f555ea69b1edd11ad6186"
SRC_URI = "git://gitenterprise.xilinx.com/OpenAMP/open-amp.git;protocol=https;branch=xlnx-2016.3"

S = "${WORKDIR}/git"

DEPENDS = "libmetal"

inherit pkgconfig cmake

EXTRA_OECMAKE = " \
	-DLIB_INSTALL_DIR=${libdir} \
	-DLIBEXEC_INSTALL_DIR=${libexecdir} \
	-DMACHINE=${SOC_FAMILY} \
	-DWITH_PROXY=OFF \
	"

EXTRA_OECMAKE_append_zynqmp = "-DWITH_APPS=ON"
