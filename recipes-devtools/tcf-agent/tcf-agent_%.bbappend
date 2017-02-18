LIC_FILES_CHKSUM_microblaze = "file://${S}/MicroBlaze-TCF-agent-1.3.0.txt;md5=58995e08ee9d03f05320573c9f0cd909"

MAKE_ARCH_aarch64 = "a64"

# Hardware Breakpoint support does not work correctly for Zynq or Zynqmp
CFLAGS_append_aarch64 = " -DENABLE_SSL=0 -DUSE_uuid_generate=0 -DENABLE_HardwareBreakpoints=0"
CFLAGS_append_armv7a  = " -DENABLE_HardwareBreakpoints=0"

SRCREV = "09e01bf681699fa8433ef5c5fd5171cb8bf4d97c"
PV = "1.4.0"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	git://git.eclipse.org/gitroot/tcf/org.eclipse.tcf.agent.git;branch=master;protocol=https \
	file://fix_ranlib.patch \
	file://tcf-agent.init \
	file://tcf-agent.service \
	"

MB_TCF_NAME="mb-tcf-agent-v2016.3"
SRC_URI_microblaze = " \
	http://www.author.xilinx.com/guest_resources/member/mb_gnu/${MB_TCF_NAME}.zip;name=tcfmb \
	file://tcf-agent.init \
	"

SRC_URI[tcfmb.md5sum] = "43105d618f73fbb3ad0267fc38f3b4ff"
SRC_URI[tcfmb.sha256sum] = "5c0581ad8282f9147ff0e33738af2177482b3126aa958b41bba2a98cd22f76e9"

CFLAGS_remove += " \
		  -DSERVICE_RunControl=0 \
		  -DSERVICE_Breakpoints=0 \
		  -DSERVICE_Memory=0 \
 		  -DSERVICE_Registers=0 \
                  -DSERVICE_MemoryMap=0 \
		  -DSERVICE_StackTrace=0 \
                  -DSERVICE_Symbols=0 \
                  -DSERVICE_LineNumbers=0 \
		  -DSERVICE_Expressions=0 \
		  "

EXTRA_OEMAKE_append = " 'LINK_OPTS=${LDFLAGS}'"

S_microblaze="${WORKDIR}/${MB_TCF_NAME}"

do_compile_microblaze(){
:
}

do_install_microblaze() {
	install -d ${D}/usr/sbin
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/tcf-agent.init ${D}${sysconfdir}/init.d/tcf-agent
	install -m 0755 ${S}/agent ${D}/usr/sbin/tcf-agent
}
INSANE_SKIP_${PN}_microblaze = "ldflags"
INSANE_SKIP_${PN}-dev_microblaze = "ldflags"
INSANE_SKIP_${PN}-staticdev_microblaze = "ldflags"
