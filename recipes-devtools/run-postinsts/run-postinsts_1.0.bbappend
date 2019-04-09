do_install_append(){
    sed -i -e 's:eval sh -c $i $append_log:$(sh -c $i $append_log):g'  ${D}${sbindir}/run-postinsts
}
