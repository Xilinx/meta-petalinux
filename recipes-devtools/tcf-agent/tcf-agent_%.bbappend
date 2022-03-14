# Need to duplicate this, as the URL has changed.
SRC_URI = "git://git.eclipse.org/r/tcf/org.eclipse.tcf.agent.git;protocol=https \
           file://fix_ranlib.patch \
           file://ldflags.patch \
           file://tcf-agent.init \
           file://tcf-agent.service \
          "

# TCF Agent: fixed handling of line info file names when file contains a mix DWARF 5 and DWARF 3
CFLAGS:append:aarch64 = " -DENABLE_SSL=0 -DUSE_uuid_generate=1 -DENABLE_HardwareBreakpoints=0"
CFLAGS:append:armv7a  = " -DENABLE_HardwareBreakpoints=0"
CFLAGS:append:microblaze = " -DENABLE_SSL=0 -DUSE_uuid_generate=0"

SRCREV = "b9401083f976cd2409e7449e5344a4b406782704"


MAKE_ARCH:microblaze = "microblaze"

EXTRA_OEMAKE:append = " 'LINK_OPTS=${LDFLAGS}'"

