# Using amd64 assembly fails when building for mingw32
EXTRA_OECONF_append_mingw32 = " --disable-amd64-as-feature-detection"
