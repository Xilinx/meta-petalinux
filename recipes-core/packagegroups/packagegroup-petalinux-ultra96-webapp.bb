DESCRIPTION = "Required packages for ultra96 startup pages"

inherit packagegroup

ULTRA96_STARTUP_PAGES_PACKAGES = " \
	ultra96-startup-pages \
	chromium \
	ace-cloud-editor \
	python-flask \
	python-werkzeug \
	python-jinja2 \
	python-markupsafe \
	python-itsdangerous \
	"

RDEPENDS_${PN} = "${ULTRA96_STARTUP_PAGES_PACKAGES}"
