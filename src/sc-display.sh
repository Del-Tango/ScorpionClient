#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_banners () {
    if [ -z "${MD_DEFAULT['banner']}" ]; then
        return 1
    fi
    case "${MD_DEFAULT['banner']}" in
        *','*)
            for cargo_key in `echo ${MD_DEFAULT['banner']} | sed 's/,/ /g'`; do
                ${MD_CARGO[$cargo_key]} "${MD_DEFAULT['conf-file']}"
            done
            ;;
        *)
            ${MD_CARGO[${MD_DEFAULT['banner']}]} "${MD_DEFAULT['conf-file']}"
            ;;
    esac
    return $?
}
# CODE DUMP

# DEPRECATED
function display_project_settings () {
    echo "[ ${CYAN}Banner${RESET}         ]: ${MAGENTA}${MD_DEFAULT['banner']}${RESET}
[ ${CYAN}Log File${RESET}       ]: ${YELLOW}`basename ${MD_DEFAULT['log-dir']}`/`basename ${MD_DEFAULT['log-file']}`${RESET}
[ ${CYAN}Log Lines${RESET}      ]: ${WHITE}${MD_DEFAULT['log-lines']}${RESET}
[ ${CYAN}ScorpionC Addr${RESET} ]: ${RED}${MD_DEFAULT['sc-addr']}${RESET}
[ ${CYAN}ScorpionC Port${RESET} ]: ${RED}${MD_DEFAULT['sc-port']}${RESET}
[ ${CYAN}ScorpionC User${RESET} ]: ${RED}${MD_DEFAULT['sc-user']}${RESET}
[ ${CYAN}ScorpionC Pass${RESET} ]: ${RED}${MD_DEFAULT['sc-pass']}${RESET}" | column
    echo; return $?
}

