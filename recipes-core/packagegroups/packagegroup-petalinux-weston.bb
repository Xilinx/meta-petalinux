DESCRIPTION = "PetaLinux Weston packages"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "wayland"

WESTON_PACKAGES = " \
	weston \
	weston-init \
	weston-examples \
	${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'weston-xwayland', '', d)} \
	"

WAYLAND_PACKAGES = " \
	wayland \
	wayland-protocols \
	"

BENCHMARKS_EXTRA = " \
	glmark2 \
	"

RDEPENDS_${PN} = "${WESTON_PACKAGES} ${WAYLAND_PACKAGES} ${BENCHMARKS_EXTRA}"
