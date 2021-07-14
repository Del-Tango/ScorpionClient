#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# HOT BANNER

REMOTE='github.com'
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`
RESET=`tput sgr0`

function display_internet_access () {
    ping -c 1 $REMOTE &> /dev/null
    case $? in
        0)
            echo "${GREEN}ON${RESET}"
            ;;
        *)
            echo "${RED}OFF${RESET}"
            ;;
    esac
    return $?
}

function display_external_ipv4_address () {
    curl whatismyip.akamai.com 2> /dev/null
    return $?
}

function display_local_ipv4_address () {
    ifconfig | grep inet | grep '\.' | grep broadcast | awk '{print $2}'
    return $?
}

function display_hot_banner () {
    INTERNET=`display_internet_access`
    EXTERNAL_IPV4=( `display_external_ipv4_address` )
    LOCAL_IPV4=( `display_local_ipv4_address` )
    cat<<EOF
    ${CYAN}External IPv4${RESET}   : ${MAGENTA}${EXTERNAL_IPV4[0]}${RESET}
    ${CYAN}Local IPv4${RESET}      : ${MAGENTA}${LOCAL_IPV4[0]}${RESET}
    ${CYAN}Internet Access${RESET} : $INTERNET
EOF
}

display_hot_banner
