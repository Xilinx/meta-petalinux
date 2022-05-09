OUTFILE_NAME = "${TOPDIR}/pnlist.json"
python () {
    import re
    outfile_name = d.getVar('OUTFILE_NAME') or ''
    pn = d.getVar('PN')
    pv = d.getVar('PV')
    description = d.getVar('DESCRIPTION')
    rdepends = d.getVar('RDEPENDS:%s' % pn) or ''
    rdepends = re.sub("[\(\[].*?[\)\]]", "", rdepends)
    packages = d.getVar('PACKAGES') or ''
    packages = re.sub("[\(\[].*?[\)\]]", "", packages)

    # Add -dev,-dbg,-ptest manually if packagegroup inherited
    if bb.data.inherits_class('packagegroup', d):
        packages += ' %s-dev %s-dbg' % (pn, pn)
        if bb.utils.contains('DISTRO_FEATURES', 'ptest', True, False, d):
            packages += ' %s-ptest' % pn

    with open(outfile_name, 'a') as outfile_name_f:
        string = '"%s": {\n' \
                 '    "version": "%s",\n' \
                 '    "description": "%s",\n' \
                 '    "rdepends": [%s],\n' \
                 '    "packages": [%s]\n },\n' % (pn, \
                                  pv, \
                                  re.sub(r'["|\'|\t|\\]+', ' ',description), \
                                  ', '.join(['"{}"'.format(c) for c in rdepends.split()]), \
                                  ', '.join(['"{}"'.format(c) for c in packages.split()]))
        outfile_name_f.write(string)
    outfile_name_f.close()
}
