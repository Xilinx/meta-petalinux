# Workaround for clang not supporting big.LITTLE
TUNE_CCARGS:remove_cortexa72-cortexa53 = "-mtune=cortex-a72.cortex-a53"
TUNE_CCARGS:append_cortexa72-cortexa53 = " -mtune=cortex-a53"

