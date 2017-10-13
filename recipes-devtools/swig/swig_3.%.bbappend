FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
		file://0001-Add-Node-7.x-aka-V8-5.2-support.patch \
		file://0002-Remove-warnings-on-Node-6.x-aka-V8-5.0-and-5.1.patch \
		"

