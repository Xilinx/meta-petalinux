do_install_append(){
    sed -i -e 's:eval sh -c $i $append_log:eval sh -c $i 2>\&1 $append_log:g'  ${D}${sbindir}/run-postinsts
}
