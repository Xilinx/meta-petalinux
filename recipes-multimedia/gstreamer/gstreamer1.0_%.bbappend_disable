BRANCH ?= "xlnx-rebase-v1.18.5"
REPO   ?= "git://github.com/Xilinx/gstreamer.git;protocol=https"

BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

PV = "1.18.5+git${SRCPV}"

SRC_URI = " \
    ${REPO};${BRANCHARG};name=gstreamer-xlnx \
    file://run-ptest \
    file://0001-gst-gstpluginloader.c-when-env-var-is-set-do-not-fal.patch \
    file://0002-Remove-unused-valgrind-detection.patch \
    file://0003-tests-seek-Don-t-use-too-strict-timeout-for-validati.patch \
    file://0004-tests-respect-the-idententaion-used-in-meson.patch \
    file://0005-tests-add-support-for-install-the-tests.patch \
    file://0006-tests-use-a-dictionaries-for-environment.patch \
    file://0007-tests-install-the-environment-for-installed_tests.patch \
"

SRCREV_gstreamer-xlnx = "e483cd3a0894f4d5270cdb80a62baf1df24ccf89"
SRCREV_FORMAT = "gstreamer-xlnx"

PACKAGECONFIG:append = " tracer-hooks coretracers"

S = "${WORKDIR}/git"
