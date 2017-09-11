FILESEXTRAPATHS_prepend := "${THISDIR}/gstreamer1.0:"

SRC_URI_append = " \
    file://0001-tee-Implement-allocation-query-aggregation.patch \
    file://0002-tee-Add-test-for-the-allocation-query.patch \
    file://0003-tee-Allocate-one-more-buffer-when-multi-plexing.patch \
"
