DESCRIPTION = "CPU benchmark to measure floating point performance"
HOMEPAGE = "https://en.wikipedia.org/wiki/Whetstone_(benchmark)"
SECTION = "benchmark/tests"

LICENSE = "GPLv1"
LIC_FILES_CHKSUM ="file://${COMMON_LICENSE_DIR}/GPL-1.0;md5=e9e36a9de734199567a4d769498f743d"

SRC_URI = "http://www.netlib.org/benchmark/whetstone.c"
SRC_URI[md5sum] = "d8eb2cd7104bb5a12d614ac6d3f1f9fb"
SRC_URI[sha256sum] = "333e4ceca042c146f63eec605573d16ae8b07166cbc44a17bec1ea97c6f1efbf"

S = "${WORKDIR}"

do_compile () {
	${CC} ${CFLAGS} ${LDFLAGS} -O3 -Ofast -o whetstone whetstone.c -lm
}

do_install () {
	install -d ${D}${bindir}
	install -m 0755 whetstone ${D}${bindir}
}

