#!/bin/sh
# uninstalls Tentris from the system

set -eu

ask_remove_database() {
    while true; do
        read -p "Do you also want to remove the database files at /var/local/tentris? [Y/N] " action
        case "$action" in
            [yY]*)
                sudo rm -rf /var/local/tentris || true
                break
                ;;
            [nN]*)
                break
                ;;
        esac
    done
}

ask_remove_config_files() {
    while true; do
        read -p "Do you also want to remove the config files at /etc/tentris.d? [Y/N] " action
        case "$action" in
            [yY]*)
                sudo rm -rf /etc/tentris.d || true
                break
                ;;
            [nN]*)
                break
                ;;
        esac
    done
}

while true; do
    read -p "Are you sure you want to uninstall tentris and all its accompanying files? [Y/N] " action

    case "$action" in
        [yY]*)
            sudo rm /usr/local/bin/tentris || true
            sudo rm /etc/systemd/system/tentris@.service || true
            ask_remove_config_files
            ask_remove_database
            echo "Done"
            break
            ;;
        [nN]*)
            break
            ;;
    esac
done
