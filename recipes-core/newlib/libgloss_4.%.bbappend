# When building multiple, we need to depend on the multilib newlib
DEPENDS:append:xilinx-standalone:baremetal-multilib-tc = " ${MLPREFIX}newlib"

