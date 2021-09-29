PACKAGECONFIG = "disable-weak-ciphers ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11-fwd', '', d)}"

PACKAGECONFIG[x11-fwd] = ""

do_configure:append() {
	if ${@bb.utils.contains('PACKAGECONFIG', 'x11-fwd', 'true', 'false', d)} ; then
		echo "#define DROPBEAR_X11FWD 1" >> ${B}/localoptions.h
	fi
}

# Create a Package to configure dropbear to use openssh-sftp-server
PACKAGES =+ "${PN}-openssh-sftp-server"
RDEPENDS:${PN}-openssh-sftp-server += "openssh-sftp-server ${PN}"

FILES:${PN}-openssh-sftp-server = "/usr/libexec/sftp-server"

do_install:prepend() {
	mkdir -p ${D}/usr/libexec
	ln -s /usr/lib/openssh/sftp-server ${D}/usr/libexec/sftp-server
}
