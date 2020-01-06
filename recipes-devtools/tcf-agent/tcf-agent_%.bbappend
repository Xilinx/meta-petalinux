# Hardware Breakpoint support does not work correctly for Zynq or Zynqmp
CFLAGS_append_aarch64 = " -DENABLE_SSL=0 -DUSE_uuid_generate=1 -DENABLE_HardwareBreakpoints=0"
CFLAGS_append_armv7a  = " -DENABLE_HardwareBreakpoints=0"
CFLAGS_append_microblaze = " -DENABLE_SSL=0 -DUSE_uuid_generate=0"

SRCREV = "370968b8e63bb3cc3d3edb4f0b16478dee6fa78b"

MAKE_ARCH_microblaze = "microblaze"

EXTRA_OEMAKE_append = " 'LINK_OPTS=${LDFLAGS}'"

