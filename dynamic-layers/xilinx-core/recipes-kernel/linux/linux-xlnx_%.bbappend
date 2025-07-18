# Include plnx cfg if plnx flow and microblaze and KERNEL_AUTO_CONFIG is set
INCLUDE_PLNX_KCFG ?= "${@'1' if d.getVar('WITHIN_PLNX_FLOW') and  d.getVar('KERNEL_AUTO_CONFIG') else ''}"
# Include SYSCONFIG_DIR
PLNX_SYSCONFIG_KDIR ?= "${@'%s/linux-xlnx' % d.getVar('SYSCONFIG_DIR') if d.getVar('SYSCONFIG_DIR') else ''}"

FILESEXTRAPATHS:prepend := "${@'${PLNX_SYSCONFIG_KDIR}:' if d.getVar('INCLUDE_PLNX_KCFG') and d.getVar('PLNX_SYSCONFIG_KDIR') else ''}"
SRC_URI += "${@'file://plnx_kernel.cfg' if d.getVar('INCLUDE_PLNX_KCFG') and d.getVar('PLNX_SYSCONFIG_KDIR') else ''}"
