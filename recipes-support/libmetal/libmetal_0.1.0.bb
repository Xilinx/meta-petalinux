SUMMARY = "Libmetal : Libmetal implements an abstraction layer across user-space Linux, baremetal, and RTOS environments"

HOMEPAGE = "https://github.com/OpenAMP/libmetal/"

SECTION = "libs"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=395307789d21fd8945fc1c933cad18b5"

# Inital tag of libmetal xilinx-v2016.3
SRCREV ?= "cf86806f3a6cac15fce7cf4e1f4190d9afee610c"
SRC_URI = "git://github.com/Xilinx/libmetal.git;protocol=https;branch=xlnx-2016.3"

S = "${WORKDIR}/git"

DEPENDS = "libhugetlbfs sysfsutils"

inherit pkgconfig cmake

EXTRA_OECMAKE = " \
	-DLIB_INSTALL_DIR=${libdir} \
	-DLIBEXEC_INSTALL_DIR=${libexecdir} \
	-DMACHINE=${SOC_FAMILY} \
	"

# Only builds the library but not the demo apps.
#EXTRA_OECMAKE_append_zynqmp = "-DWITH_EXAMPLES=ON"
