SUMMARY = "Microblaze Target Communication Framework Binary for the Eclipse IDE"

LICENSE = "EPL-1.0 | EDL-1.0"
LIC_FILES_CHKSUM = "file://${S}/MicroBlaze-TCF-agent-1.3.0.txt;md5=58995e08ee9d03f05320573c9f0cd909"

SRC_URI[md5sum] = "43105d618f73fbb3ad0267fc38f3b4ff"
SRC_URI[sha256sum] = "5c0581ad8282f9147ff0e33738af2177482b3126aa958b41bba2a98cd22f76e9"

COMPATIBLE_MACHINE = "(-)"
COMPATIBLE_MACHINE_microblaze = "(.*)"

PROVIDES = "tcf-agent"
RPROVIDES_${PN} = "tcf-agent"

MB_TCF_NAME="mb-tcf-agent-v2016.3"
SRC_URI = "http://www.author.xilinx.com/guest_resources/member/mb_gnu/${MB_TCF_NAME}.zip"

S="${WORKDIR}/${MB_TCF_NAME}"

do_install() {
	install -d ${D}/usr/sbin
	cp -a ${S}/agent ${D}/usr/sbin/tcf-agent
}
