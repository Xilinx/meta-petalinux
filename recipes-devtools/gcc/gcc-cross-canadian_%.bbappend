require gcc-xilinx-standalone-multilib.inc

# We want to use the stock multilib configs, when available
EXTRACONFFUNCS:xilinx-standalone = ""

EXTRA_OECONF:append:xilinx-standalone = " \
        --enable-multilib \
"
