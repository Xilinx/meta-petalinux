TOOLCHAIN_HOST_TASK += "\
	nativesdk-qttools-tools \
	nativesdk-qtbase-tools \
"

create_sdk_files_append () {
	echo 'export PETALINUX_NATIVE_SYSROOT="${SDKPATHNATIVE}"' >> $script
}
