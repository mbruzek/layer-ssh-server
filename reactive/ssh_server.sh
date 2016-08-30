#!/bin/bash
set -ex

source charms.reactive.sh


@when_not 'ssh-server.installed'
function install_ssh-server() {
    apt-get install openssh-server
    charms.reactive set_state 'ssh-server.installed'
}

@when 'ssh-server.installed'
@when 'config.changed.port'
function configure_port() {
    local port=`config-get port`
    status-set maintenance "Configuring sshd for ${port}"
    sed -i -e "s/^Port .*$/Port ${port}/" /etc/ssh/sshd_config 
    systemctl reload sshd 
    systemctl status sshd
    open-port $port
    status-set active "The ssh-server is listening to ${port}"
}

reactive_handler_main
