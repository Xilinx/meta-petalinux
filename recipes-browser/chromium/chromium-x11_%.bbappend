# Workaround for clang not supporting big.LITTLE
TUNE_CCARGS:remove:cortexa72-cortexa53 = "-mtune=cortex-a72.cortex-a53"
TUNE_CCARGS:append:cortexa72-cortexa53 = " -mtune=cortex-a53"
TUNE_CCARGS:remove:cortexa72-cortexa53 = "-mcpu=cortex-a72.cortex-a53"
TUNE_CCARGS:append:cortexa72-cortexa53 = " -mcpu=cortex-a53"
GN_ARGS:remove = "use_lld=true use_gold=false"

# Fix for compilation failures
DEPENDS += "libxshmfence"
