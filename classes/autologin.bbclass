# Allow logins as root, even if a password is set.  Note this ignores the userid passed to getty!
ROOTFS_POSTPROCESS_COMMAND:append = '${@bb.utils.contains_any("IMAGE_FEATURES", "debug-tweaks", "autologin_root ; ", "", d)}'

AUTOLOGIN_USER ?= "root"

autologin_root() {
	bbwarn "Enabling autologin to user ${AUTOLOGIN_USER}.  This configuration should NOT be used in production!"

	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		# Add a console service
		if [ -e ${IMAGE_ROOTFS}/${systemd_system_unitdir}/console-getty.service ]; then
			sed -e 's,ExecStart=-/sbin/agetty ,ExecStart=-/sbin/agetty -a ${AUTOLOGIN_USER} ,' \
				-i ${IMAGE_ROOTFS}/${systemd_system_unitdir}/console-getty.service
		fi

		if [ -e ${IMAGE_ROOTFS}/${systemd_system_unitdir}/getty@.service ]; then
			sed -e 's,ExecStart=-/sbin/agetty ,ExecStart=-/sbin/agetty -a ${AUTOLOGIN_USER} ,' \
				-i ${IMAGE_ROOTFS}/${systemd_system_unitdir}/getty@.service
		fi

		if [ -e ${IMAGE_ROOTFS}/${systemd_system_unitdir}/serial-getty@.service ]; then
			sed -e 's,ExecStart=-/sbin/agetty ,ExecStart=-/sbin/agetty -a ${AUTOLOGIN_USER} ,' \
				-i ${IMAGE_ROOTFS}/${systemd_system_unitdir}/serial-getty@.service
		fi
	fi

	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		cat << EOF > ${IMAGE_ROOTFS}/bin/autologin
#!/bin/sh
exec /bin/login -f ${AUTOLOGIN_USER}
EOF
		chmod 0755 ${IMAGE_ROOTFS}/bin/autologin
	fi
}

