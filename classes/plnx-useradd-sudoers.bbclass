# Add one or more users to the sudoers
# This is done by creating a new /etc/sudoers.d/99-petalinux.conf

# Provide a list of users, and their associated access info in
# EXTRA_USERS_SUDOERS, such as:
#
# USERADDEXTENSION:append = " plnx-useradd-sudoers"
#
# EXTRA_USERS_SUDOERS = "\
# xilinx	ALL = (ALL) ALL;\
# %wheel	ALL = (ALL) ALL;\
# "

PACKAGE_INSTALL:append = " ${@['', 'sudo'][bool(d.getVar('EXTRA_USERS_SUDOERS'))]}"

ROOTFS_POSTPROCESS_COMMAND:append = " set_sudoers;"

set_sudoers () {
	sudoers_settings="${EXTRA_USERS_SUDOERS}"
	export PSEUDO="${FAKEROOTENV} ${STAGING_DIR_NATIVE}${bindir}/pseudo"
	setting=`echo $sudoers_settings | cut -d ';' -f1`
	remaining=`echo $sudoers_settings | cut -d ';' -f2-`
	while test "x$setting" != "x"; do
		eval "$PSEUDO echo \"$setting\" >> \"${IMAGE_ROOTFS}\"/etc/sudoers.d/99-petalinux"
		setting=`echo $remaining | cut -d ';' -f1`
		remaining=`echo $remaining | cut -d ';' -f2-`
	done
	if [ -f "${IMAGE_ROOTFS}/etc/sudoers.d/99-petalinux" ]; then
		eval "$PSEUDO chmod 0440 \"${IMAGE_ROOTFS}\"/etc/sudoers.d/99-petalinux"
	fi
}
