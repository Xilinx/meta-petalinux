# While fetching all the package information using smart info command, we found
# performance to be slower.  By using source rpm, package locaton, description
# and other package info with smart query is comparatively faster than smart
# info command

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += " \
	file://0001-smart-query-enable-other-packages-information-to-sho.patch \
	file://0001-smart-check-for-empty-problems-list.patch \
	"
