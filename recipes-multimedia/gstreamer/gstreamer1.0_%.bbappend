FILESEXTRAPATHS_prepend := "${THISDIR}/gstreamer1.0:"

SRC_URI_append = " \
    file://0001-tee-Implement-allocation-query-aggregation.patch \
"
