TOOLCHAIN_HOST_TASK += "\
    nativesdk-qttools \
    nativesdk-qtbase-tools \
    nativesdk-libbz2 \
"

create_sdk_files_append () {
	echo 'export PETALINUX_NATIVE_SYSROOT="${SDKPATHNATIVE}"' >> $script
}
