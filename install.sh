#!/bin/bash

function if-executable() {
    local BIN=$(command -v "$1" 2>/dev/null)
    if [[ ! $BIN == "" && -x $BIN ]]; then return 0; else return 1; fi
}

function echo_info() {
    echo -e "$(tput setaf 2)>>$(tput sgr0) $1"
}

function main() {
    if ! if-executable brew;then
        echo_info "Install brew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
 
    echo_info "Update & Upgrage brew"
    brew update
    brew upgrade
    
    apps=(
        openconnect
    )
    
    echo_info "Install module"
    brew install "${apps[@]}"
    
    # copy vpnrc template
    if [ ! -f $HOME/.vpnrc ]; then
        echo_info "Create config file: $HOME/.vpnrc"
        cp ./.vpnrc $HOME/
    else
        echo_info "$HOME/.vpnrc file already existed"
    fi
}

main "$@"
