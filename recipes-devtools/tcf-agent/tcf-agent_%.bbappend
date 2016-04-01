COMPATIBLE_MACHINE = "(-)"
COMPATIBLE_MACHINE_zynqmp = "(.*)"
COMPATIBLE_MACHINE_zynq = "(.*)"

MAKE_ARCH_aarch64 = "a64"

# Hardware Breakpoint support does not work correctly for Zynq or Zynqmp
CFLAGS_append_aarch64 = " -DENABLE_SSL=0 -DUSE_uuid_generate=0 -DENABLE_HardwareBreakpoints=0"
CFLAGS_append_armv7a  = " -DENABLE_HardwareBreakpoints=0"

SRCREV = "afff85a6cb7f15edc00139f9adbbd23c2e28549e"

SRC_URI = " \
	git://git.eclipse.org/gitroot/tcf/org.eclipse.tcf.agent.git;branch=master;protocol=https \
	file://fix_ranlib.patch \
	file://tcf-agent.init \
	file://tcf-agent.service \
	"

CFLAGS_remove += " \
		  -DSERVICE_RunControl=0 \
		  -DSERVICE_Breakpoints=0 \
		  -DSERVICE_Memory=0 \
 		  -DSERVICE_Registers=0 \
                  -DSERVICE_MemoryMap=0 \
		  -DSERVICE_StackTrace=0 \
                  -DSERVICE_Symbols=0 \
                  -DSERVICE_LineNumbers=0 \
		  -DSERVICE_Expressions=0 \
		  "
