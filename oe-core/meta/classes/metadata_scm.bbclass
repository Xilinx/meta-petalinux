# Switch the metadata branch and revision to meta-petalinux

METADATA_BRANCH := "${@oe.buildcfg.get_metadata_git_branch(d.getVar('PETALINUX_COREBASE'))}"
METADATA_BRANCH[vardepvalue] = "${METADATA_BRANCH}"
METADATA_REVISION := "${@oe.buildcfg.get_metadata_git_revision(d.getVar('PETALINUX_COREBASE'))}"
METADATA_REVISION[vardepvalue] = "${METADATA_REVISION}"
