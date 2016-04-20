SUMMARY = "Microblaze Target Communication Framework Binary for the Eclipse IDE"

LICENSE = "EPL-1.0 | EDL-1.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/MicroBlaze-TCF-agent-1.3.0.txt;md5=58995e08ee9d03f05320573c9f0cd909"

SRC_URI[md5sum] = "e86b33e15e4c0a1536c148bcc9bcf43c"
SRC_URI[sha256sum] = "70d4c83524c1544ca0c184a504955213d2f4448b3e65c5dfc79eb13009cc2143"

COMPATIBLE_MACHINE = "(-)"
COMPATIBLE_MACHINE_microblaze = "(.*)"

PROVIDES = "tcf-agent"
RPROVIDES_${PN} = "tcf-agent"

SRC_URI = "http://www.author.xilinx.com/guest_resources/member/mb_gnu/mb-tcf-agent.zip"

do_install() {
	install -d ${D}/usr/sbin
	cp -a ${WORKDIR}/agent ${D}/usr/sbin/tcf-agent
}
