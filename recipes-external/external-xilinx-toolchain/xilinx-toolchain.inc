XILINX_VER_MAIN ??= ""

python () {
	if not d.getVar("XILINX_VER_MAIN", True):
		raise bb.parse.SkipPackage("External toolchain not configured (XILINX_VER_MAIN not set).")
}

do_install[vardepsexclude] += "EXTERNAL_TOOLCHAIN EXTERNAL_TOOLCHAIN_SYSROOT XILINX_VER_MAIN EXTERNAL_TOOLCHAIN_DBGROOT"
