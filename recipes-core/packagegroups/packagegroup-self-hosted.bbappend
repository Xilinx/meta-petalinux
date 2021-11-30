REQUIRED_DISTRO_FEATURES:remove = "x11"

PACKAGES:remove = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', '', 'packagegroup-self-hosted-graphics', d)} \
"

RDEPENDS:packagegroup-self-hosted:remove = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', '', 'packagegroup-self-hosted-graphics', d)} \
"

RDEPENDS:packagegroup-self-hosted-extended:remove = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', '', 'settings-daemon', d)} \
    openssh-ssh \
    openssh-scp \
    openssh-sftp-server \
"

RDEPENDS:packagegroup-self-hosted-graphics:remove = " \
    builder \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', '', 'libgl libgl-dev libglu libglu-dev', d)} \
"
