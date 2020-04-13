DESCRIPTION = "Required packages for ultra96 startup pages"

inherit packagegroup

REQUIRED_DISTRO_FEATURES = "x11"

ULTRA96_STARTUP_PAGES_PACKAGES = " \
	chromium-x11 \
	ace-cloud-editor \
	python3-flask \
	python3-werkzeug \
	python3-jinja2 \
	python3-markupsafe \
	python3-itsdangerous \
	connman \
	connman-client \
	connman-tools \
	"

ULTRA96_STARTUP_PAGES_PACKAGES_append_ultra96-zynqmp = " ultra96-ap-setup ultra96-startup-pages"

RDEPENDS_${PN} = "${ULTRA96_STARTUP_PAGES_PACKAGES}"
