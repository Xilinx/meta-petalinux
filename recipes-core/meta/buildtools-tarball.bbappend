TOOLCHAIN_HOST_TASK += "\
	nativesdk-python3-sqlite3 \
	nativesdk-python3-pyyaml \
	nativesdk-qemu-xilinx \
	nativesdk-bootgen \
"

create_sdk_files_append () {
	echo 'export PETALINUX_NATIVE_SYSROOT="${SDKPATHNATIVE}"' >> $script
	echo 'export PETALINUX_NATIVE_QEMU="${SDKPATHNATIVE}${bindir}/qemu-xilinx"' >> $script
}
