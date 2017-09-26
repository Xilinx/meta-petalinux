LIC_FILES_CHKSUM_microblaze = "file://${S}/MicroBlaze-TCF-agent-1.3.0.txt;md5=58995e08ee9d03f05320573c9f0cd909"

MAKE_ARCH = "`echo ${TARGET_ARCH} | sed s,i.86,i686, | sed s,aarch64,a64,`"

# Hardware Breakpoint support does not work correctly for Zynq or Zynqmp
CFLAGS_append_aarch64 = " -DENABLE_SSL=0 -DUSE_uuid_generate=0 -DENABLE_HardwareBreakpoints=0"
CFLAGS_append_armv7a  = " -DENABLE_HardwareBreakpoints=0"

SRCREV = "0b69483e10fd1cf6866e7c78fa6eb61dd3487e9d"
PV = "1.4.0"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	git://git.eclipse.org/gitroot/tcf/org.eclipse.tcf.agent.git;branch=master;protocol=https \
	file://fix_ranlib.patch;striplevel=2 \
	file://ldflags.patch \
	file://tcf-agent.init \
	file://tcf-agent.service \
	"

MB_TCF_NAME="mb-tcf-agent-2017-3"
SRC_URI_microblaze = " \
       https://www.xilinx.com/content/dam/xilinx/guest-resources/${MB_TCF_NAME}.zip;name=tcfmb \
       file://tcf-agent.init \
       "

SRC_URI[tcfmb.md5sum] = "401ca34c7b0a8fb4a2a82c421c033661"
SRC_URI[tcfmb.sha256sum] = "3a9f03d2a7b74efa3b54fe5f8bdc1be2e1039377252534161112c54a6145abe5"

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

S_microblaze = "${WORKDIR}/mb-agent-2017-3"

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
