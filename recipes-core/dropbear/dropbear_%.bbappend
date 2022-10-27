PACKAGECONFIG += "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11-fwd', '', d)}"

PACKAGECONFIG[x11-fwd] = ""

do_configure:append() {
	if ${@bb.utils.contains('PACKAGECONFIG', 'x11-fwd', 'true', 'false', d)} ; then
		echo "#define DROPBEAR_X11FWD 1" >> ${B}/localoptions.h
		# Fixed a bug in dropbear, see https://github.com/mkj/dropbear/issues/156
		echo "#define DROPBEAR_CHANNEL_PRIO_INTERACTIVE DROPBEAR_PRIO_LOWDELAY" >> ${B}/localoptions.h
	fi
}
