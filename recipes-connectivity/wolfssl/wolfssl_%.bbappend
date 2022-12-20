PACKAGECONFIG += "${@bb.utils.contains("TUNE_FEATURES","crypto","crypto","",d)}"
PACKAGECONFIG[crypto] = "--enable-armasm,--disable-armasm"
