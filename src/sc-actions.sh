#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# ACTIONS

function action_scorpion_cloud_connect () {
    echo; info_msg "Jumping to ${RED}Scorpion Cloud${RESET}..."
    ${SC_CARGO['ssh-machine']} "${SC_DEFAULT['sc-user']}" \
        "${SC_DEFAULT['sc-addr']}" "${SC_DEFAULT['sc-port']}" \
        "${SC_DEFAULT['sc-pass']}" 2> /dev/null
    echo; return $?
}

function action_set_remote_address () {
    echo; info_msg "Type ${RED}Scorpion Cloud${RESET} address or"\
        "(${MAGENTA}.back${RESET})."
    while :
    do
        local ADDRESS=`fetch_data_from_user 'SC-Address'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        if [ -z "$ADDRESS" ]; then
            fetch_ultimatum_from_user "No server address provided! Leave blank? Y/N"
            if [ $? -eq 0 ]; then
                break
            fi; continue
        fi; break
    done
    echo; set_remote_address $ADDRESS
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) default"\
            "${RED}remote address${RESET} to (${RED}$ADDRESS${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}remote address${RESET} to (${GREEN}$ADDRESS${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_remote_port () {
    echo; info_msg "Type ${RED}Scorpion Cloud${RESET} port number or"\
        "(${MAGENTA}.back${RESET})."
    while :
    do
        local PORT_NUMBER=`fetch_data_from_user 'SC-Port'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        if [ -z "$PORT_NUMBER" ]; then
            fetch_ultimatum_from_user "No port nmber provided! Leave blank? Y/N"
            if [ $? -eq 0 ]; then
                break
            fi; continue
        fi
        check_value_is_number $PORT_NUMBER
        if [ $? -ne 0 ]; then
            warning_msg "${RED}Scorpion Cloud${RESET} port number required,"\
                "not (${RED}$PORT_NUMBER${RESET})."
            echo; continue
        fi; break
    done
    echo; set_remote_port $PORT_NUMBER
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) default"\
            "${RED}remote port number${RESET} to (${RED}$PORT_NUMBER${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}remote port number${RESET} to (${GREEN}$PORT_NUMBER${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_remote_user () {
    echo; info_msg "Type ${RED}Scorpion Cloud${RESET} user name or"\
        "(${MAGENTA}.back${RESET})."
    while :
    do
        local USER=`fetch_data_from_user 'SC-User'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        if [ -z "$USER" ]; then
            fetch_ultimatum_from_user "No user name provided! Leave blank? Y/N"
            if [ $? -eq 0 ]; then
                break
            fi; continue
        fi; break
    done
    echo; set_remote_user $USER
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) default"\
            "${RED}remote user${RESET} to (${RED}$USER${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}remote user${RESET} to (${GREEN}$USER${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_remote_password () {
    echo; info_msg "Type ${RED}Scorpion Cloud${RESET} user password or"\
        "(${MAGENTA}.back${RESET})."
    while :
    do
        local PASSWORD=`fetch_data_from_user 'SC-Password'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        if [ -z "$PASSWORD" ]; then
            fetch_ultimatum_from_user "No password provided! Leave blank? Y/N"
            if [ $? -eq 0 ]; then
                break
            fi; continue
        fi; break
    done
    echo; set_remote_password $PASSWORD
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) default"\
            "${RED}remote password${RESET} to (${RED}$PASSWORD${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}remote password${RESET} to (${GREEN}$PASSWORD${RESET})."
    fi
    return $EXIT_CODE
}

function action_install_dependencies () {
    echo
    fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    apt_install_dependencies
    return 0
}

function action_set_log_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exists."
            echo; continue
        fi; break
    done
    echo; set_log_file "$FILE_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) log file."
    else
        ok_msg "Successfully set (${BLUE}$SCRIPT_NAME${RESET}) log file"\
            "(${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_log_lines () {
    echo; info_msg "Type log line number to display or (${MAGENTA}.back${RESET})."
    while :
    do
        LOG_LINES=`fetch_data_from_user 'LogLines'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_value_is_number $LOG_LINES
        if [ $? -ne 0 ]; then
            warning_msg "LogViewer number of lines required,"\
                "not (${RED}$LOG_LINES${RESET})."
            echo; continue
        fi; break
    done
    echo; set_log_lines $LOG_LINES
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) default"\
            "${RED}log lines${RESET} to (${RED}$LOG_LINES${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}log lines${RESET} to (${GREEN}$LOG_LINES${RESET})."
    fi
    return $EXIT_CODE
}


