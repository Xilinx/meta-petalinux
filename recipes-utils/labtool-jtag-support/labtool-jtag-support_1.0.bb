DESCRIPTION = "Labtool (hw_server, xsdb, xvc_server) support for vck190 system controller"
SUMMARY = "Labtool (hw_server, xsdb, xvc_server) support for vck190 system controller"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://../LICENSE;beginline=1;endline=31;md5=3b8f316b2ccb7dfb1179567709cda049"

SRC_URI = "git://gitenterprise.xilinx.com/smartlynq/systemctl-labtool-yocto.git;branch=master;protocol=https \
           file://LICENSE "
SRC_URI[md5sum] = "a476e19d5c4666e91bcab4cd8b09c3dd"
SRC_URI[sha256sum] = "0da1edcb0177f844b69ceb70aed864672983fa40bbe92b4df01e0d6c34795c15"

SRCREV = "b221c0ccccb3231b7ff4e32e2b537f3873d5d366"

inherit update-rc.d

INSANE_SKIP_${PN} = "ldflags"
INHIBIT_PACKAGE_STRIP = "1"

INITSCRIPT_NAME = "xsdb"
INITSCRIPT_PARAMS = "start 99 S ."

S="${WORKDIR}/git"

SOLIBS = ".so"
FILES_SOLIBSDEV = ""
FILES_${PN} += "${prefix}/local ${prefix}/local/bin ${prefix}/local/lib ${prefix}/local/lib/tcl8.5 \
                ${prefix}/local/xilinx_vitis ${base_libdir}/ \
		${base_libdir}/libtcl8.5.so ${base_libdir}/libtcltcf.so \
		${sysconfdir}/init.d"


COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_vck-sc-zynqmp = "vck-sc-zynqmp"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure[noexec]="1"
do_compile[noexec]="1"

do_install () {
    install -d ${D}${libdir}/
    install -d ${D}${prefix}/local/
    install -d ${D}${prefix}/local/bin/
    install -d ${D}${prefix}/local/lib/
    install -d ${D}${prefix}/local/lib/tcl8.5/
    install -d ${D}${prefix}/local/xilinx_vitis/
    install -d ${D}${sysconfdir}/init.d/

    cp  ${S}${libdir}/* ${D}${libdir}/
    cp -r ${S}${prefix}/local/lib/tcl8.5 ${D}${prefix}/local/lib/
    cp  ${S}${prefix}/local/bin/* ${D}${prefix}/local/bin/
    cp -r  ${S}${prefix}/local/xilinx_vitis ${D}${prefix}/local/
    cp  ${S}${sysconfdir}/init.d/xsdb ${D}${sysconfdir}/init.d/

}
