#! /bin/bash

# Unsets the following so it does not show up in the term title
unset SSH_CONNECTION

lnav_test="${top_builddir}/src/lnav-test"

for fn in ${srcdir}/tui-captures/*; do
    base_fn=`basename $fn`
    run_test ./scripty -n -e $fn -- ${lnav_test} -H < /dev/null

    case "$base_fn" in
    tui_echo.0)
      on_error_log "Skipping $fn"
      ;;
    *)
      on_error_fail_with "TUI test ${fn} does not work?"
      ;;
    esac
done

run_test ./scripty -n -e ${srcdir}/xpath_tui.0 -- \
    ${lnav_test} -I ${test_dir} \
        -c ':goto 2' \
        ${srcdir}/logfile_xml_msg.0

on_error_fail_with "xpath() fields are not working?"
