FILESEXTRAPATHS_prepend  := "${THISDIR}/files:"

SRC_URI_append = " \
	file://mask-CPUID-support-in-HWCAP-on-aarch64.patch \
	file://0001-Fix-391861-Massif-Assertion-n_ips-1-n_ips-VG_-clo_ba.patch \
"
