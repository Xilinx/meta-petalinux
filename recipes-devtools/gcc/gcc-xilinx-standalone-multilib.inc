# Both arm and armv*r overrides are set w/ cortex r5
# So only set rmprofile if armv*r is defined.
ARM_PROFILE = "aprofile"
ARM_PROFILE:armv7r = "rmprofile"
ARM_PROFILE:armv8r = "rmprofile"
EXTRA_OECONF:append:xilinx-standalone:arm:baremetal-multilib-tc = " \
        --with-multilib-list=${ARM_PROFILE} \
        "

