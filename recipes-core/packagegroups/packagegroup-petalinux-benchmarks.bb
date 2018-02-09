DESCRIPTION = "PetaLinux packages for Benchmarks"

inherit packagegroup

BENCHMARKS_EXTRAS = " \
	hdparm \
	iotop \
	nicstat \
	lmbench \
	iptraf \
	net-snmp \
	lsof \
	babeltrace \
	sysstat \
	dstat \
	dhrystone \
	linpack \
	whetstone \
	iperf3 \
	"
RDEPENDS_${PN} = "${BENCHMARKS_EXTRAS}"
