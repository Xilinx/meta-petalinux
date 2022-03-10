# The build (TOPDIR) and TMPDIR may not be inside of EXTERNALSRC or
# EXTERNALSRC_BUILD
#
# This can result in errors about files (usually lockfiles) going
# away during a build, such as:
#
# FileNotFoundError: [Errno 2] No such file or directory: '.../singletask.lock

python () {
    if bb.data.inherits_class('externalsrc', d):
        topdir = d.getVar('TOPDIR')
        tmpdir = d.getVar('TMPDIR')
        externalsrc = d.getVar('EXTERNALSRC')
        externalsrcbuild = d.getVar('EXTERNALSRC_BUILD')

        if externalsrc and topdir.startswith(externalsrc):
            bb.error("TOPDIR may not be inside of EXTERNALSRC")
        if externalsrcbuild and topdir.startswith(externalsrc):
            bb.error("TOPDIR may not be inside of EXTERNALSRC_BUILD")
        if externalsrc and tmpdir.startswith(externalsrc):
            bb.error("TMPDIR may not be inside of EXTERNALSRC")
        if externalsrcbuild and tmpdir.startswith(externalsrc):
            bb.error("TMPDIR may not be inside of EXTERNALSRC_BUILD")
}
