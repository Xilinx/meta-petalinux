# Zap the root password if debug-tweaks feature is not
ROOTFS_POSTPROCESS_COMMAND += '${@bb.utils.contains_any("IMAGE_FEATURES","debug-tweaks", "autologin_root ; ","", d)}'

autologin_root() {
	echo -e '#!/bin/sh\nexec /bin/login -f root' > ${IMAGE_ROOTFS}/bin/autologin
	chmod 0755 ${IMAGE_ROOTFS}/bin/autologin
}

