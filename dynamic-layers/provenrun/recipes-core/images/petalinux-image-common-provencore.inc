PROVENCORE_INSTALL = " \
    provencore-driver \
    libprovencore \
    provenrun-uppercase \
    "

IMAGE_INSTALL:append = " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'provencore', '${PROVENCORE_INSTALL}', '', d)} \
    "
