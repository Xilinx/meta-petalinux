require ${COREBASE}/meta/classes-recipe/rootfs-postcommands.bbclass

# Allow autologin when both sysvinit AND systemd are enabled

#
# Autologin the 'root' user on the serial terminal,
# if empty-root-password' AND 'serial-autologin-root are enabled
#
serial_autologin_root () {
	if ${@bb.utils.contains("DISTRO_FEATURES", "sysvinit", "true", "false", d)}; then
		if [ -e "${IMAGE_ROOTFS}${base_bindir}/start_getty" ]; then
			# add autologin option to util-linux getty only
			sed -i 's/options="/&--autologin root /' \
				"${IMAGE_ROOTFS}${base_bindir}/start_getty"
		fi
	fi
	if ${@bb.utils.contains("DISTRO_FEATURES", "systemd", "true", "false", d)}; then
		if [ -e ${IMAGE_ROOTFS}${systemd_system_unitdir}/serial-getty@.service ]; then
			sed -i '/^\s*ExecStart\b/ s/getty /&--autologin root /' \
				"${IMAGE_ROOTFS}${systemd_system_unitdir}/serial-getty@.service"
		fi
	fi
}
