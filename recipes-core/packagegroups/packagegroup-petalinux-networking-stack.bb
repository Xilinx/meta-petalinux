DESCRIPTION = "PetaLinux packages to extend network stack"

inherit packagegroup

NETWORKING_STACK_PACKAGES = " \
	ethtool \
	phytool \
	netcat \
	net-tools \
	dnsmasq \
	iproute2 \
	iptables \
	rpcbind \
	"

RDEPENDS_${PN} = "${NETWORKING_STACK_PACKAGES}"
