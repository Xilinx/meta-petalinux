REQUIRED_DISTRO_FEATURES_remove = "x11"

PACKAGES_remove = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', '', 'packagegroup-self-hosted-graphics', d)} \
"

RDEPENDS_packagegroup-self-hosted_remove = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', '', 'packagegroup-self-hosted-graphics', d)} \
"

RDEPENDS_packagegroup-self-hosted-extended_remove = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', '', 'settings-daemon', d)} \
"

RDEPENDS_packagegroup-self-hosted-graphics_remove = " \
    builder \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', '', 'libgl libgl-dev libglu libglu-dev', d)} \
"
