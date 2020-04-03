# Allow logins as root, even if a password is set.  Note this ignores the userid passed to getty!
ROOTFS_POSTPROCESS_COMMAND += '${@bb.utils.contains_any("IMAGE_FEATURES","debug-tweaks", "autologin_root ; ","", d)}'

autologin_root() {
	cat << EOF > ${IMAGE_ROOTFS}/bin/autologin
#!/bin/sh
exec /bin/login -f root
EOF
	chmod 0755 ${IMAGE_ROOTFS}/bin/autologin
}

