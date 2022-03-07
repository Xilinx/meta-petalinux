# Need to duplicate this, as the URL has changed.
SRC_URI = "git://git.eclipse.org/r/tcf/org.eclipse.tcf.agent.git;protocol=https \
           file://fix_ranlib.patch \
           file://ldflags.patch \
           file://tcf-agent.init \
           file://tcf-agent.service \
          "

# TCF Agent: fixed handling of line info file names in DWARF 5
CFLAGS:append:aarch64 = " -DENABLE_SSL=0 -DUSE_uuid_generate=1 -DENABLE_HardwareBreakpoints=0"
CFLAGS:append:armv7a  = " -DENABLE_HardwareBreakpoints=0"
CFLAGS:append:microblaze = " -DENABLE_SSL=0 -DUSE_uuid_generate=0"

SRCREV = "b6b35195cd59a4ae54858863114dc5b4dabd93ca"


MAKE_ARCH:microblaze = "microblaze"

EXTRA_OEMAKE:append = " 'LINK_OPTS=${LDFLAGS}'"

