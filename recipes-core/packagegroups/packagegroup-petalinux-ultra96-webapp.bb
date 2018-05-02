DESCRIPTION = "Required packages for ultra96 startup pages"

inherit packagegroup

ULTRA96_STARTUP_PAGES_PACKAGES = " \
	chromium \
	ace-cloud-editor \
	python-flask \
	python-werkzeug \
	python-jinja2 \
	python-markupsafe \
	python-itsdangerous \
	"

ULTRA96_STARTUP_PAGES_PACKAGES_append_ultra96-zynqmp = " ultra96-startup-pages"

RDEPENDS_${PN} = "${ULTRA96_STARTUP_PAGES_PACKAGES}"
