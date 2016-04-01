# Create a Package to configure dropbear to use openssh-sftp-server
PACKAGES =+ "${PN}-openssh-sftp-server"
RDEPENDS_${PN}-openssh-sftp-server += "openssh-sftp-server ${PN}"

FILES_${PN}-openssh-sftp-server = "/usr/libexec/sftp-server"

do_install_prepend() {
	mkdir -p ${D}/usr/libexec
	ln -s /usr/lib/openssh/sftp-server ${D}/usr/libexec/sftp-server
}
