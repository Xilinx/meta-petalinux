# This class is based on oe-core's extrausers.bbclass and
# useradd_base.bbclass as of commit 3cf69fba8542e6ebbdb754c7616cf2ad44eec6ff
#
# The purpose is to add the ability to expire passwords.
#
# The class has been modified to work as a "USERADDEXTENSION" class

# Add the new functionality, from useradd_base.bbclass
perform_passwd_expire () {
	local rootdir="$1"
	local opts="$2"
	bbnote "${PN}: Performing equivalent of passwd --expire with [$opts]"
	# Directly set sp_lstchg to 0 without using the passwd command: Only root can do that
	local username=`echo "$opts" | awk '{ print $NF }'`
	local user_exists="`grep "^$username:" $rootdir/etc/passwd || true`"
	if test "x$user_exists" != "x"; then
		eval flock -x $rootdir${sysconfdir} -c \"$PSEUDO sed -i \''s/^\('$username':[^:]*\):[^:]*:/\1:0:/'\' $rootdir/etc/shadow \" || true
		local passwd_lastchanged="`grep "^$username:" $rootdir/etc/shadow | cut -d: -f3`"
		if test "x$passwd_lastchanged" != "x0"; then
			bbfatal "${PN}: passwd --expire operation did not succeed."
		fi
	else
		bbnote "${PN}: user $username doesn't exist, not expiring its password"
	fi
}

# Override set_user_group to call the perform_passwd_expire as needed
# Image level user / group settings
set_user_group () {
	user_group_settings="${EXTRA_USERS_PARAMS}"
	export PSEUDO="${FAKEROOTENV} ${STAGING_DIR_NATIVE}${bindir}/pseudo"
	setting=`echo $user_group_settings | cut -d ';' -f1`
	remaining=`echo $user_group_settings | cut -d ';' -f2-`
	while test "x$setting" != "x"; do
		cmd=`echo $setting | cut -d ' ' -f1`
		opts=`echo $setting | cut -d ' ' -f2-`
		# Different from useradd.bbclass, there's no file locking issue here, as
		# this setting is actually a serial process. So we only retry once.
		case $cmd in
			useradd)
				perform_useradd "${IMAGE_ROOTFS}" "-R ${IMAGE_ROOTFS} $opts"
				;;
			groupadd)
				perform_groupadd "${IMAGE_ROOTFS}" "-R ${IMAGE_ROOTFS} $opts"
				;;
			userdel)
				perform_userdel "${IMAGE_ROOTFS}" "-R ${IMAGE_ROOTFS} $opts"
				;;
			groupdel)
				perform_groupdel "${IMAGE_ROOTFS}" "-R ${IMAGE_ROOTFS} $opts"
				;;
			usermod)
				perform_usermod "${IMAGE_ROOTFS}" "-R ${IMAGE_ROOTFS} $opts"
				;;
			passwd-expire)
				perform_passwd_expire "${IMAGE_ROOTFS}" "$opts"
				;;
			groupmod)
				perform_groupmod "${IMAGE_ROOTFS}" "-R ${IMAGE_ROOTFS} $opts"
				;;
			*)
				bbfatal "Invalid command in EXTRA_USERS_PARAMS: $cmd"
				;;
		esac
		# Avoid infinite loop if the last parameter doesn't end with ';'
		if [ "$setting" = "$remaining" ]; then
			break
		fi
		# iterate to the next setting
		setting=`echo $remaining | cut -d ';' -f1`
		remaining=`echo $remaining | cut -d ';' -f2-`
	done
}
