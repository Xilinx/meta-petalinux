# Using amd64 assembly fails when building for mingw32
EXTRA_OECONF:append:mingw32 = " --disable-amd64-as-feature-detection"
