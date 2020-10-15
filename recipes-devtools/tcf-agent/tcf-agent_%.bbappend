# Hardware Breakpoint support does not work correctly for Zynq or Zynqmp
CFLAGS_append_aarch64 = " -DENABLE_SSL=0 -DUSE_uuid_generate=1 -DENABLE_HardwareBreakpoints=0"
CFLAGS_append_armv7a  = " -DENABLE_HardwareBreakpoints=0"
CFLAGS_append_microblaze = " -DENABLE_SSL=0 -DUSE_uuid_generate=0"

SRCREV = "cc85ef7ac6768c62521d35119e0f2808e18fc0d6"


MAKE_ARCH_microblaze = "microblaze"

EXTRA_OEMAKE_append = " 'LINK_OPTS=${LDFLAGS}'"

