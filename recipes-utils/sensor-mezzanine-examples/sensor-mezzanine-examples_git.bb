LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=6ec9b8bb223a49edcf575e97fbf78061"

SRC_URI = "git://github.com/96boards/Sensor_Mezzanine_Getting_Started.git;protocol=https \
        file://0001-96Boards-Sensors-examples-Modify-examples-to-run-on-.patch \
        file://0002-Added-run_me.sh-to-all-examples.patch \
        file://0003-rgb_lcd-Modify-demo-to-run-with-python3.patch \
        file://0004-tweeting_doorbell-Modify-demo-to-work-with-python3.patch \
        file://0005-touch_switch.cpp-Connect-the-touch-sensor-to-differe.patch \
        file://0006-upgrade-humid-temp-examples-to-python3.patch \
        file://0007-Added-backup-files-to-all-the-source-files.patch \
        file://0001-upgrade-humid-temp-examples-to-latest-python3-versio.patch \
"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "6456fdf28c66bb3ab10ed3d4c5ae3d2a0c97952f"

FILES_${PN} = "/usr/share/Sensor_Mezzanine_Getting_Started"

DEPENDS += "rsync-native"
RDEPENDS_${PN} = "bash"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE_ultra96 = "${MACHINE}"

PACKAGE_ARCH_ultra96 = "${BOARD_ARCH}"

do_install () {
    install -d ${D}${datadir}/Sensor_Mezzanine_Getting_Started
    rsync -r --exclude=".*" ${S}/* ${D}${datadir}/Sensor_Mezzanine_Getting_Started

    chmod +x ${D}${datadir}/Sensor_Mezzanine_Getting_Started/button_led/run_me.sh
    chmod +x ${D}${datadir}/Sensor_Mezzanine_Getting_Started/humid_temp/run_me.sh
    chmod +x ${D}${datadir}/Sensor_Mezzanine_Getting_Started/light_buzz/run_me.sh
    chmod +x ${D}${datadir}/Sensor_Mezzanine_Getting_Started/touch_switch/run_me.sh
    chmod +x ${D}${datadir}/Sensor_Mezzanine_Getting_Started/tweeting_doorbell/run_me.sh
    chmod +x ${D}${datadir}/Sensor_Mezzanine_Getting_Started/rgb_lcd_demo/run_me.sh

}

