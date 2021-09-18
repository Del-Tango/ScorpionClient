#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETUP

function project_setup () {
    lock_and_load
    load_project_config
    create_project_menu_controllers
    setup_project_menu_controllers
    return 0
}

function setup_project_menu_controllers () {
    setup_project_dependencies
    setup_main_menu_controller
    setup_control_panel_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller setup complete."
    return 0
}

# LOADERS

function load_project_config () {
    load_project_script_name
    load_project_prompt_string
    load_settings_project_default
    load_project_logging_levels
    load_project_cargo_scripts
}

function load_project_cargo_scripts () {
    if [ ${#SC_CARGO[@]} -eq 0 ]; then
        warning_msg "No cargo scripts found docked to $SC_SCRIPT_NAME."
        return 1
    fi
    for cargo in ${!SC_CARGO[@]}; do
        load_cargo "$cargo" "${SC_CARGO[$cargo]}"
    done
    return $?
}

function load_project_prompt_string () {
    if [ -z "$SC_PS3" ]; then
        warning_msg "No default prompt string found. Defaulting to $MD_PS3."
        return 1
    fi
    if [ ! -z ${SC_DEFAULT['player-rank']} ]; then
        local PPROMPT="${RED}${SC_DEFAULT['player-rank']}${RESET}> "
    else
        local PPROMPT="${RED}${SC_PS3}${RESET}"
    fi
    set_project_prompt "$PPROMPT"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load prompt string ${RED}$SC_PS3${RESET}."
    else
        ok_msg "Successfully loaded"\
            "prompt string ${GREEN}$SC_PS3${RESET}"
    fi
    return $EXIT_CODE
}

function load_project_logging_levels () {
    if [ ${#SC_LOGGING_LEVELS[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} logging levels found."
        return 1
    fi
    MD_LOGGING_LEVELS=( ${SC_LOGGING_LEVELS[@]} )
    ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} logging levels."
    return 0
}

function load_settings_project_default () {
    if [ ${#SC_DEFAULT[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} defaults found."
        return 1
    fi
    for sc_setting in ${!SC_DEFAULT[@]}; do
        MD_DEFAULT[$sc_setting]=${SC_DEFAULT[$sc_setting]}
        ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET}"\
            "default setting"\
            "(${GREEN}$sc_setting - ${SC_DEFAULT[$sc_setting]}${RESET})."
    done
    done_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} default settings."
    return 0
}

function load_project_script_name () {
    if [ -z "$SC_SCRIPT_NAME" ]; then
        warning_msg "No default script name found. Defaulting to $SCRIPT_NAME."
        return 1
    fi
    set_project_name "$SC_SCRIPT_NAME"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load script name ${RED}$SC_SCRIPT_NAME${RESET}."
    else
        ok_msg "Successfully loaded"\
            "script name ${GREEN}$SC_SCRIPT_NAME${RESET}"
    fi
    return $EXIT_CODE
}

# SETUP DEPENDENCIES

function setup_project_dependencies () {
    setup_project_apt_dependencies
    return 0
}

function setup_project_apt_dependencies () {
    if [ ${#SC_APT_DEPENDENCIES[@]} -eq 0 ]; then
        warning_msg "No ${RED}$SCRIPT_NAME${RESET} dependencies found."
        return 1
    fi
    FAILURE_COUNT=0
    SUCCESS_COUNT=0
    for util in ${SC_APT_DEPENDENCIES[@]}; do
        add_apt_dependency "$util"
        if [ $? -ne 0 ]; then
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
        else
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    done_msg "(${GREEN}$SUCCESS_COUNT${RESET}) ${BLUE}$SCRIPT_NAME${RESET}"\
        "dependencies staged for installation using the APT package manager."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    return 0
}

# MAIN MENU SETUP

function setup_main_menu_controller () {
    setup_main_menu_option_scorpion_cloud
    setup_main_menu_option_control_panel
    setup_main_menu_option_back
    done_msg "${CYAN}$MAIN_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_main_menu_option_scorpion_cloud () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Scorpion-Cloud${RESET}"\
        "to action ${CYAN}action_scorpion_cloud_connect${RESET}"
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" 'Scorpion-Cloud' \
        'action_scorpion_cloud_connect'
    return $?
}

function setup_main_menu_option_control_panel () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Control-Panel${RESET}"\
        "to menu ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET}"
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" 'Control-Panel' "$SETTINGS_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_back () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# SETTINGS CONTROLLER

function setup_control_panel_menu_controller () {
    setup_control_panel_menu_option_set_remote_address
    setup_control_panel_menu_option_set_remote_port
    setup_control_panel_menu_option_set_remote_user
    setup_control_panel_menu_option_set_remote_password
    setup_control_panel_menu_option_set_log_file
    setup_control_panel_menu_option_set_log_lines
    setup_control_panel_menu_option_install_dependencies
    setup_control_panel_menu_option_back
    done_msg "${CYAN}$MAIN_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_control_panel_menu_option_set_remote_address () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Remote-Address${RESET}"\
        "to function ${MAGENTA}action_set_remote_address${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Remote-Address' \
        'action_set_remote_address'
    return $?
}

function setup_control_panel_menu_option_set_remote_port () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Remote-Port${RESET}"\
        "to function ${MAGENTA}action_set_remote_port${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Remote-Port' \
        'action_set_remote_port'
    return $?
}

function setup_control_panel_menu_option_set_remote_user () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Remote-User${RESET}"\
        "to function ${MAGENTA}action_set_remote_user${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Remote-User' \
        'action_set_remote_user'
    return $?
}

function setup_control_panel_menu_option_set_remote_password () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Remote-Passwd${RESET}"\
        "to function ${MAGENTA}action_set_remote_password${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Remote-Passwd' \
        'action_set_remote_password'
    return $?
}

function setup_control_panel_menu_option_set_log_file () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-File${RESET}"\
        "to function ${MAGENTA}action_set_log_file${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Log-File' 'action_set_log_file'
    return $?
}

function setup_control_panel_menu_option_set_log_lines () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-Lines${RESET}"\
        "to function ${MAGENTA}action_set_log_lines${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Log-Lines' 'action_set_log_lines'
    return $?
}

function setup_control_panel_menu_option_install_dependencies () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Install-Dependencies${RESET}"\
        "to function ${MAGENTA}action_install_dependencies${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Install-Dependencies' \
        'action_install_dependencies'
    return $?
}

function setup_control_panel_menu_option_back () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# CODE DUMP
