SUMMARY = "Configuration files for networkd and wpa_supplicant for ultra96"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit features_check

REQUIRED_DISTRO_FEATURES = "systemd"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:ultra96 = "${MACHINE}"
PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = " \
    file://wlan0.network \
    file://wpa_supplicant-wlan0.conf \
    "

RDEPENDS:${PN} = "wpa-supplicant"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${nonarch_base_libdir}/systemd/network
    install -m 644 ${WORKDIR}/wlan0.network ${D}${nonarch_base_libdir}/systemd/network/wlan0.network

    install -d ${D}${sysconfdir}/wpa_supplicant
    install -m 600 ${WORKDIR}/wpa_supplicant-wlan0.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-wlan0.conf
}

pkg_postinst_ontarget:${PN}() {
    if systemctl > /dev/null 2>&1 ; then
        systemctl enable wpa_supplicant@wlan0.service
    fi
}

FILES:${PN} += "${nonarch_base_libdir}/systemd/network"
