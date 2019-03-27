DESCRIPTION = "Required packages for ultra96 startup pages"

inherit packagegroup

ULTRA96_STARTUP_PAGES_PACKAGES = " \
	chromium \
	ace-cloud-editor \
	python3-flask \
	python3-werkzeug \
	python3-jinja2 \
	python3-markupsafe \
	python3-itsdangerous \
	"

ULTRA96_STARTUP_PAGES_PACKAGES_append_ultra96-zynqmp = " ultra96-ap-setup ultra96-startup-pages"

RDEPENDS_${PN} = "${ULTRA96_STARTUP_PAGES_PACKAGES}"
