DESCRIPTION = "Required packages for ultra96 startup pages"

COMPATIBLE_MACHINE:ultra96-zynqmp = "${MACHINE}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

ULTRA96_STARTUP_PAGES_PACKAGES = " \
	ace-cloud-editor \
	python3-flask \
	python3-werkzeug \
	python3-jinja2 \
	python3-markupsafe \
	python3-itsdangerous \
	"

ULTRA96_STARTUP_PAGES_PACKAGES:append:ultra96-zynqmp = " \
	ultra96-ap-setup \
	ultra96-startup-pages \
	ultra96-wlan0-config \
	"

RDEPENDS:${PN} = "${ULTRA96_STARTUP_PAGES_PACKAGES}"
