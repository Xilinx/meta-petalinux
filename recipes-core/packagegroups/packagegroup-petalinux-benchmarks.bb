DESCRIPTION = "PetaLinux Packages for Benchmarks"

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
	"

RDEPENDS_${PN} += "${BENCHMARKS_EXTRAS}"
