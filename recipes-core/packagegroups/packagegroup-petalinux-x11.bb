DESCRIPTION = "PetaLinux X11 related Packages"
LICENSE = "NONE"

inherit packagegroup

X11_PACKAGES = " \
	xauth \
	xhost \
	xset \
	xtscal \
	xcursor-transparent-theme \
	xinit \
	xinput \
	xinput-calibrator \
	xkbcomp \
	xkeyboard-config \
	xkeyboard-config-locale-en-gb \
	xmodmap \
	xrandr \
	xserver-nodm-init \
	"

XSERVER ?= " \
        xserver-xorg \
        xf86-input-evdev \
        xf86-input-mouse \
        xf86-input-keyboard \
        xf86-video-fbdev \
        "

MATCHBOX_PACKAGES = " \
       matchbox-config-gtk \
       matchbox-desktop \
       matchbox-keyboard \
       matchbox-keyboard-applet \
       matchbox-panel-2 \
       matchbox-session \
       matchbox-terminal \
       matchbox-theme-sato \
       matchbox-desktop-sato \
       matchbox-session-sato \
       matchbox-wm \
       sato-icon-theme \
       settings-daemon \
       "

RDEPENDS_${PN}_append_zynq += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'x11', '${XSERVER} \
			${X11_PACKAGES} ${MATCHBOX_PACKAGES}', '', d)} \
	"

RDEPENDS_${PN}_append_zynqmp += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'x11', ' xserver-xorg-extension-glx xf86-video-armsoc ${XSERVER} \
			${X11_PACKAGES} ${MATCHBOX_PACKAGES}', '', d)} \
	"
