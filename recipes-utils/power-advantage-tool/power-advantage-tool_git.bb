#
# This file is the power-advantage-tool recipe.
#

SUMMARY = "Power Advantage Tool"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit jupyter-examples python3-dir

SRC_URI = "git://github.com/Xilinx/jupyter-pat.git;protocol=https;branch=xlnx_rel_v2021.2"

PV = "2.2.0+git${SRCPV}"
SRCREV = "6a527f77fd865c2edd4463a9798486e7d34a43bf"


S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:vck-sc = "${MACHINE}"
COMPATIBLE_MACHINE:vpk-sc = "${MACHINE}"
COMPATIBLE_MACHINE:eval-brd-sc = "${MACHINE}"

RDEPENDS:${PN} = "packagegroup-petalinux-jupyter \
                  python3-ipywidgets \
                  python3-pydot \
                  "
do_install() {
    install -d ${D}/${JUPYTER_DIR}/power-advantage-tool
    install -d ${D}/${JUPYTER_DIR}/power-advantage-tool/img
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}/poweradvantage

    install -m 0755 ${S}/*.ipynb ${D}/${JUPYTER_DIR}/power-advantage-tool
    install -m 0755 ${S}/img/* ${D}/${JUPYTER_DIR}/power-advantage-tool/img
    install -m 0755 ${S}/poweradvantage/* ${D}${PYTHON_SITEPACKAGES_DIR}/poweradvantage
}

#
# The install_customize task 
# configures Power_Advantage_Tool.ipynb to the proper board and processor
# and copies the proper artwork to match the Jupyter Notebook background color
#
python do_install_customize () {
    import os
    import shutil
    token_old = "\\\"VCK190\\\", \\\"SC\\\")\\n"
    path_source = d.getVar('S') + "/img_on_black"
    path_destination = d.getVar('D') + d.getVar('JUPYTER_DIR') + "/power-advantage-tool/img"
    path_ipynb = d.getVar('D') + d.getVar('JUPYTER_DIR') + "/power-advantage-tool/Power_Advantage_Tool.ipynb"
    if d.getVar('BOARD') == 'vck-sc':
        token_new = "\\\"VCK190\\\", \\\"SC\\\")\\n"
    elif d.getVar('BOARD') == 'vmk-sc':
        token_new = "\\\"VMK180\\\", \\\"SC\\\")\\n"
    elif d.getVar('BOARD') == 'vpk-sc':
        token_new = "\\\"VPK120\\\", \\\"SC\\\")\\n"
    elif d.getVar('BOARD') == 'eval-brd-sc':
        token_new = "\\\"VCK190\\\", \\\"SC\\\")\\n"
    elif d.getVar('BOARD') == 'vck190':
        token_new = "\\\"VCK190\\\", \\\"\\\")\\n"
        shutil.rmtree(path_destination)
        shutil.copytree(path_source, path_destination)
    elif d.getVar('BOARD') == 'vmk180':
        token_new = "\\\"VMK180\\\", \\\"\\\")\\n"
        shutil.rmtree(path_destination)
        shutil.copytree(path_source, path_destination)
    elif d.getVar('BOARD') == 'vpk120':
        token_new = "\\\"VPK120\\\", \\\"\\\")\\n"
        shutil.rmtree(path_destination)
        shutil.copytree(path_source, path_destination)
    elif d.getVar('BOARD') == 'vpk180':
        token_new = "\\\"VPK180\\\", \\\"\\\")\\n"
        shutil.rmtree(path_destination)
        shutil.copytree(path_source, path_destination)
    else:
        token_new = "\\\"VCK190\\\", \\\"SC\\\")\\n"
    file = open(path_ipynb, 'r')
    lines = file.readlines()
    file.close()
    file = open(path_ipynb, 'w')
    for line in lines:
        file.write(line.replace(token_old, token_new).replace("\n", "\r\n"))
    file.close()
}
addtask install_customize after do_install before do_build

FILES:${PN} += "${PYTHON_SITEPACKAGES_DIR}/poweradvantage/* ${JUPYTER_DIR}/*"
