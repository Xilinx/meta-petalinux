FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

MOUNT_DIR ?= "/media"
SRC_URI += " \
    file://11-sd-cards-auto-mount.rules \
    "

do_install:append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/11-sd-cards-auto-mount.rules ${D}${sysconfdir}/udev/rules.d/11-sd-cards-auto-mount.rules
}

do_configure:append() {
	sed -i -e "s|@@MOUNT_DIR@@|${MOUNT_DIR}|g" "${WORKDIR}/11-sd-cards-auto-mount.rules"
}
