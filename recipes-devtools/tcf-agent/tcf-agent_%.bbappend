# TCF Agent: fixed handling of line info file names when file contains a mix DWARF 5 and DWARF 3
#CFLAGS:append:aarch64 = " -DENABLE_SSL=0 -DUSE_uuid_generate=1 -DENABLE_HardwareBreakpoints=0"
#CFLAGS:append:armv7a  = " -DENABLE_HardwareBreakpoints=0"
#CFLAGS:append:microblaze = " -DENABLE_SSL=0 -DUSE_uuid_generate=0"

MAKE_ARCH:microblaze = "microblaze"
