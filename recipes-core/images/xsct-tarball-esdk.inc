#Copy xsct tarball to esdk's download dir, where xsct-tarball class is expecting it to be
python copy_buildsystem_prepend() {

    if bb.data.inherits_class('xsct-tarball', d):
        ext_tarball = d.getVar("COPY_XSCT_TO_ESDK")
        #including xsct tarball in esdk
        if ext_tarball == '1':
            import shutil
            baseoutpath = d.getVar('SDK_OUTPUT') + '/' + d.getVar('SDKPATH')
            xsct_outdir = '%s/downloads/xsct/' % (baseoutpath)
            bb.utils.mkdirhier(xsct_outdir)
            shutil.copy(os.path.join(d.getVar("DL_DIR"), 'xsct', d.getVar("XSCT_TARBALL")), xsct_outdir)
        #not including tarball in esdk
        else:
            d.setVar('sdk_extraconf','USE_XSCT_TARBALL = "0"')
}

#Add dir with the tools to PATH
sdk_ext_postinst_append() {
    if [ "${COPY_XSCT_TO_ESDK}" = "1" ]; then
        echo "export PATH=$target_sdk_dir/tmp/sysroots-xsct/SDK/${XILINX_VER_MAIN}/bin:\$PATH" >> $env_setup_script
    fi
}
