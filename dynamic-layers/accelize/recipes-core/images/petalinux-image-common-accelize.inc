ACCELIZE_INSTALL = " \
    drmtest \
    libaccelize-drm \
    "

IMAGE_INSTALL:append = " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'accelize', '${ACCELIZE_INSTALL}', '', d)} \
    "
