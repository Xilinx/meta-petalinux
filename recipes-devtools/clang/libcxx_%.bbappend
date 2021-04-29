# Workaround for clang not supporting big.LITTLE
TUNE_CCARGS_remove_cortexa72-cortexa53 = "-mcpu=cortex-a72.cortex-a53"
TUNE_CCARGS_remove_cortexa72-cortexa53 = "-mtune=cortex-a72.cortex-a53"
