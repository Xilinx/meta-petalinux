# Both arm and armv*r overrides are set w/ cortex r5
# So only set rmprofile if armv*r is defined.
ARM_PROFILE = "aprofile"
ARM_PROFILE:armv7r = "rmprofile"
ARM_PROFILE:armv8r = "rmprofile"
EXTRA_OECONF:append:xilinx-standalone:arm:baremetal-multilib-tc = " \
        --with-multilib-list=${ARM_PROFILE} \
        "

# RISC V configuration
EXTRA_OECONF:append:xilinx-standalone:riscv:baremetal-mulitlib-tc = " \
        --with-multilib-generator='rv32i-ilp32--c;rv32im-ilp32--c;rv32imc-ilp32--;rv32iac-ilp32--;rv32imac-ilp32--;rv32imafc-ilp32f--;rv32imafdc-ilp32d--;rv64i-lp64--;rv64im-lp64--;rv64imac-lp64--;rv64imafdc-lp64d--' \
        "

