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
@when 'config.changed.port'
function configure_port() {
    local port=`config-get port`
    status-set maintenance "Configuring ssh-server for ${port}"
    local old_port=`grep -e "^Port " /etc/ssh/sshd_config | head -n 1 | cut -d ' ' -f 2`
    close-port $old_port || true
    # The /etc/ssh/sshd_config file contains keyword-argument pairs, one per 
    # line. Lines starting  with ‘#’ and empty lines are interpreted as 
    # comments. Arguments may optionally be enclosed in double quotes (") in
    # order to represent arguments containing spaces.
    sed -i -e "s/^Port .*$/Port ${port}/" /etc/ssh/sshd_config 
    systemctl reload sshd 
    systemctl status sshd
    open-port $port
    status-set active "The ssh-server is listening to ${port}"
}

reactive_handler_main
