addhandler plnx_sanity_check
plnx_sanity_check[eventmask] = "bb.event.SanityCheck"
python plnx_sanity_check() {
    skip_check = e.data.getVar('SKIP_META_PETALINUX_SANITY_CHECK') == "1"
    if skip_check:
        return

    provencore_layer = 'provenrun' in e.data.getVar('BBFILE_COLLECTIONS').split()
    provencore_feature = 'provencore' in e.data.getVar('MACHINE_FEATURES').split()
    if not provencore_layer and provencore_feature:
        bb.warn("You have enabled provencore in MACHINE_FEATURES, but not \
included the provencore layer in your project.  This will prevent the \
provencore components from being available.")
}

