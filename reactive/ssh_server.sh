#!/bin/bash
set -ex

source charms.reactive.sh


@when_not 'ssh-server.installed'
function install_ssh-server() {
    apt-get install openssh-server
    charms.reactive set_state 'ssh-server.installed'
    status-set active "The ssh-server software is installed."
}

@when 'ssh-server.installed'
@when 'config.changed.ports'
function configure_port() {
    local ports=`config-get ports`
    status-set maintenance "Configuring ssh-server for ${ports[@]}"
    # Close the old ports.
    local old_ports=(`grep -e "^Port" /tmp/sshd_config | cut -d ' ' -f 2`)
    for port in ${old_ports[@]}; do
        echo "Closing ${port}"
        close-port $port || true
    done
    # Remove all instances of Port in the config file.
    sed -i -e '/Port/d' /etc/ssh/sshd_config
    for port in ${ports[@]}; do
        echo "Port ${port}" >> /etc/ssh/sshd_config
        open-port $port
    done
    # Reload the service and print the status.
    systemctl reload sshd 
    systemctl status sshd
    status-set active "The ssh-server is listening on ${ports[@]}"
}

reactive_handler_main
