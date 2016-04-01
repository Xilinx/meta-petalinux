TOOLCHAIN_HOST_TASK += "\
    nativesdk-pseudo \
    nativesdk-pkgconfig \
    nativesdk-unfs3 \
    nativesdk-opkg \
    nativesdk-libtool \
    nativesdk-autoconf \
    nativesdk-automake \
    nativesdk-shadow \
    nativesdk-makedevs \
    nativesdk-smartpm \
    nativesdk-update-rc.d \
    nativesdk-postinst-intercept \
    nativesdk-packagegroup-sdk-host \
    nativesdk-qttools \
    nativesdk-qtbase-tools \
    nativesdk-libbz2 \
    "

create_sdk_files_append () {
	echo 'export OECORE_NATIVE_SYSROOT="${SDKPATHNATIVE}"' >> $script
}
