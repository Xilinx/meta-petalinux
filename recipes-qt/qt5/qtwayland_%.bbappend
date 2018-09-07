FILESEXTRAPATHS_prepend := "${THISDIR}/qtwayland:"

SRC_URI_append = " \
    file://0001-qwaylandwindow.cpp-Do-not-destroy-shell-suface-befor.patch \
    file://0002-Handle-maximize-minimize-fullscreen-in-xdg_shell_v6.patch \
    file://0003-qwaylandeglwindow.cpp-Bind-the-context-before-callin.patch \
    file://0001-Fix-regression-in-QWaylandGlContext-makeCurrent-for-.patch \
"

PACKAGECONFIG = " \
    wayland-client \
    wayland-server \
    wayland-egl \
    drm-egl-server \
"
