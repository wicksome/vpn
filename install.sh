#!/bin/bash

if-executable() {
    local BIN=$(command -v "$1" 2>/dev/null)
    if [[ ! $BIN == "" && -x $BIN ]]; then true; else false; fi
}

if if-executable brew;then
    echo "not found: brew"
    exit 1
fi

brew update
brew upgrade

apps=(
    openconnect
    gpg
    pass
)

brew install "${apps[@]}"

# copy vpnrc template
cp ./.vpnrc $HOME/

