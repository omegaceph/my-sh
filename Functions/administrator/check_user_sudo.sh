#!/bin/bash

check_user_in_sudoers() {
    local sudoers_file=/etc/sudoers
    
    local line_found=$(grep -P "^$USER\s+" $sudoers_file)
    
    if [ -n "$line_found" ]; then
        printf "\n\e${Yellow}The user $USER is in the sudoers.${NC}\n"
    else
        printf "\n\e${Red}The user $USER it is not in the sudoers.${NC}\n"
        printf "${Bold}Do you want to add $USER in the sudoers file? [Y/n]${NC} "
        read add_user_to_sudoers
        if [[ $add_user_to_sudoers == [Yy] ]]; then
            echo -e "$USER ALL=(ALL:ALL) ALL" >> $sudoers_file
        fi
        cat $sudoers_file | more
    fi
}
check_user_in_sudoers