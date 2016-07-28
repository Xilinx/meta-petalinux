DESCRIPTION = "PetaLinux Packages for Benchmarks"
LICENSE = "NONE"

inherit packagegroup

BENCHMARKS_EXTRAS = " \
	iotop \
	nicstat \
	lmbench \
	iptraf \
	net-snmp \
	lsof \
	lttng-tools \
	babeltrace \
	sysstat \
	dstat \
	netperf \
	"


RDEPENDS_${PN}_append_zynqmp += " \
	${BENCHMARKS_EXTRAS} \
	"
