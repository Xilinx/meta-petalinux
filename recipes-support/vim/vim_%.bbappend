inherit pkgconfig

do_install_append (){
	rm -f ${D}${datadir}/applications/vim.desktop
}


PACKAGECONFIG_append = " gtkgui x11"

PACKAGECONFIG[gtkgui] = "--enable-gui=gtk2,--enable-gui=no,gtk+,"
PACKAGECONFIG[x11] = "--with-x,--without-x,libxt,"

ALTERNATIVE_${PN} = "vi vim gvim"
ALTERNATIVE_LINK_NAME[gvim] = "${bindir}/gvim"
