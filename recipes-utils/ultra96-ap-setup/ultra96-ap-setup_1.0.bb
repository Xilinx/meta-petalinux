DESCRIPTION = "Creates access point(AP) on ultra96"
SUMMARY = "Reads MAC address from board and splits the interface to create AP"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://ap.sh;beginline=2;endline=26;md5=27af9029002476f1d14c5035d94e65e7"

SRC_URI = "file://ap.sh \
	file://udhcpd.conf \
	file://wpa_ap.conf \
	file://ultra96-ap-setup.sh \
	"

FILES_${PN} += "${datadir}/wpa_ap"

inherit update-rc.d

INITSCRIPT_NAME = "ultra96-ap-setup.sh"
INITSCRIPT_PARAMS = "start 99 S ."

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_ultra96 = "${MACHINE}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

RDEPENDS_${PN} = "wpa-supplicant busybox"

S = "${WORKDIR}"

do_install () {
    install -d ${D}${datadir}/wpa_ap
    install -d ${D}${sysconfdir}/init.d/

    install -m 0755 ${WORKDIR}/ultra96-ap-setup.sh ${D}${sysconfdir}/init.d/ultra96-ap-setup.sh
    install -m 0644 ${WORKDIR}/wpa_ap.conf  ${D}${datadir}/wpa_ap/wpa_ap.conf
    install -m 0644 ${WORKDIR}/udhcpd.conf  ${D}${datadir}/wpa_ap/udhcpd.conf
    install -m 0755 ${WORKDIR}/ap.sh	${D}${datadir}/wpa_ap/ap.sh

}

PACKAGE_ARCH_ultra96 = "${BOARD_ARCH}"
