DESCRIPTION = "LINPACK Benchmarks are a measure of a system's floating point computing power"
HOMEPAGE = "https://en.wikipedia.org/wiki/LINPACK_benchmarks"
SECTION = "benchmark/tests"

LICENSE = "BSD"
LIC_FILES_CHKSUM ="file://${COMMON_LICENSE_DIR}/BSD;md5=3775480a712fc46a69647678acb234cb"

SRC_URI = "http://ftp4.se.freebsd.org/pub/misc/linpacknew.c"
SRC_URI[md5sum] = "11aec219fc065a4aa54b9aed3b2c6f47"
SRC_URI[sha256sum] = "e21ab7b04732189b550070f346970db9686d2f33a5d0a1a3a03c4dc50f7af14c"

S = "${WORKDIR}"

do_compile () {
	${CC} ${CFLAGS} ${LDFLAGS} -O -o linpack linpacknew.c -lm
}

do_install () {
	install -d ${D}${bindir}
	install -m 0755 linpack ${D}${bindir}
}

