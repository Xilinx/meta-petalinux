FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI_append = " \
	file://0001-src-egl-eglinfo-Align-EXT_platform_device-extension-.patch \
	file://0002-src-egl-eglinfo-Use-EGL_PLATFORM_DEVICE_EXT-only-if-.patch \
"
