DESCRIPTION = "PetaLinux Packages for Benchmarks"
LICENSE = "NONE"

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
