# Prevent boot delay on devices with multiple network interfaces

# From the systemd-networkd-wait-online.service man page:
# NAME
# systemd-networkd-wait-online.service, 
# systemd-networkd-wait-online@.service, systemd-networkd-wait-online - 
# Wait for network to come online
#
# DESCRIPTION
# systemd-networkd-wait-online is a oneshot system service (see 
# systemd.service(5)), that waits for the network to be configured. By 
# default, it will wait for all links it is aware of and which are 
# managed by systemd-networkd.service(8) to be fully configured or 
# failed, and for at least one link to be online. Here, online means 
# that the link's operational state is equal or higher than "degraded". 
# The threshold can be configured by --operational-state= option.
#
# ...
# OPTIONS
# ...
# --any
#
#   Even if several interfaces are in configuring state, 
#   systemd-networkd-wait-online exits with success when at least one 
#   interface becomes online. When this option is specified with 
#   --interface=, then systemd-networkd-wait-online waits for one of the 
#   specified interfaces to be online. This option is useful when some 
#   interfaces may not have carrier on boot.
#

do_install:append() {
    sed -i '/ExecStart/ s/$/ --any/' ${D}${systemd_system_unitdir}/systemd-networkd-wait-online.service
}
