DESCRIPTION = "PetaLinux Packages for Benchmarks"
LICENSE = "NONE"

inherit packagegroup

BENCHMARKS_EXTRAS = " \
	hdparm \
	iperf \
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
	"

RDEPENDS_${PN}_append_zynqmp += " \
	${BENCHMARKS_EXTRAS} \
	"
