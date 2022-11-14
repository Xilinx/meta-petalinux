ACCELIZE_INSTALL = " \
    accelize-drmselftest \
    libaccelize-drm \
    "

IMAGE_INSTALL:append = " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'accelize', '${ACCELIZE_INSTALL}', '', d)} \
    "
