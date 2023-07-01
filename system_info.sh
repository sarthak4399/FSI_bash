#!/bin/bash

display_table_header() {
    printf "+-----------------+-----------------+\n"
    printf "|       Type      |      Details    |\n"
    printf "+-----------------+-----------------+\n"
}

display_table_row() {
    printf "| %-15s | %-15s |\n" "$1" "$2"
}

display_table_footer() {
    printf "+-----------------+-----------------+\n"
}

display_system_users() {
    display_table_header
    cut -d: -f1 /etc/passwd | while IFS= read -r user; do
        display_table_row "User" "$user"
    done
    display_table_footer
}

display_network_information() {
    display_table_header
    ifconfig | while IFS= read -r line; do
        display_table_row "Network" "$line"
    done
    display_table_footer
}

display_password_information() {
    display_table_header
    cat /etc/passwd | while IFS= read -r line; do
        display_table_row "Password" "$line"
    done
    display_table_footer
}

display_user_permissions() {
    display_table_header
    ls -l /home | while IFS= read -r line; do
        display_table_row "Permissions" "$line"
    done
    display_table_footer
}

perform_port_scan() {
    local host=$1
    local port_range=$2

    display_table_header
    for port in $(seq $port_range); do
        timeout 1 nc -zv $host $port &>/dev/null
        if [[ $? -eq 0 ]]; then
            display_table_row "Port $port" "Open"
        else
            display_table_row "Port $port" "Closed"
        fi
    done
    display_table_footer
}

echo "System Users:"
display_system_users

echo
echo "Network Information:"
display_network_information

echo
echo "Password Information:"
display_password_information

echo
echo "User Permissions:"
display_user_permissions

echo
echo "Port Scanning:"
perform_port_scan "localhost" "1-100"
