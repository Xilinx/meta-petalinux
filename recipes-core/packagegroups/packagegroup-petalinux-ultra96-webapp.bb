DESCRIPTION = "Required packages for ultra96 startup pages"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "x11"

ULTRA96_STARTUP_PAGES_PACKAGES = " \
	chromium-x11 \
	ace-cloud-editor \
	python3-flask \
	python3-werkzeug \
	python3-jinja2 \
	python3-markupsafe \
	python3-itsdangerous \
	"

ULTRA96_STARTUP_PAGES_PACKAGES:append:ultra96 = " \
	ultra96-ap-setup \
	ultra96-startup-pages \
	ultra96-wlan0-config \
	"

RDEPENDS:${PN} = "${ULTRA96_STARTUP_PAGES_PACKAGES}"

COMPATIBLE_MACHINE:ultra96 = "${MACHINE}"

PACKAGE_ARCH:ultra96 = "${MACHINE_ARCH}"
