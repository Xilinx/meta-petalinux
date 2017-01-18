DESCRIPTION = "CPU Benchmark to measure integer performance"
SECTION = "benchmark/tests"
HOMEPAGE = "http://en.wikipedia.org/wiki/Dhrystone"

LICENSE = "NCSA"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/NCSA;md5=1b5fdec70ee13ad8a91667f16c1959d7"

SRC_URI = "http://fossies.org/linux/privat/old/dhrystone-${PV}.tar.gz"

SRC_URI[md5sum] = "15e13d1d2329571a60c04b2f05920d24"
SRC_URI[sha256sum] = "8c8da46c34fde271b8f60a96a432164d2918706911199f43514861f07ef6b2f1"

EXTRA_OEMAKE = "'GCC=${CC}' 'CFL=${CFLAGS}' 'LFLAGS=${LDFLAGS}' 'PROGS=unix' 'TIME_FUNC=-DTIME' \
		 'HZ=60' 'OPTIMIZE=-O4' 'GCCOPTIM=-O'"
S = "${WORKDIR}"

do_install () {

	install -d ${D}${bindir}
	install -m 0755 gcc_dry2  ${D}${bindir}
	install -m 0755 gcc_dry2reg  ${D}${bindir}
}
