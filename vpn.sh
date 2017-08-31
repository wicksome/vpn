#!/bin/bash

readonly VERSION="1.0.0"
readonly BASE_DIR=$(dirname "$0")
readonly ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

#------------------------------------------------------------------------------
# Config login info
# TODO: if fetch-otp is fail, exit script
set -a
. "$HOME/.vpnrc"

readonly USER="$VPN_STR_USER"
readonly SERVER="$VPN_STR_SERVER"

readonly PASSWORD="$VPN_CMD_PASSWORD"
readonly PASSWORD_SECOND="python $BASE_DIR/fetch-otp.py \
'$VPN_STR_IMAP' \
'$VPN_STR_MAIL_ID' \
$($VPN_CMD_MAIL_PASSWORD) \
'$VPN_STR_KEYWORD_OF_MAIL_TITLE_FOR_SEARCH' \
'$VPN_REGEX_FOR_GETTING_PASSWORD_TO_MAIL_CONTENT'"

set +a

# check config
if [ -z $USER ] || [ -z $SERVER ]; then
  warning=" $(tput setaf 3)✔︎ $(tput sgr0)"
  echo -e "$warning Please set your login config."
  echo -e "$warning path: $HOME/.vpnrc"
  exit 1
fi
#------------------------------------------------------------------------------

ECHO_PREFIX=" $(tput setaf 2)>>$(tput sgr0)"
DATA_PREFIX="  $(tput setaf 4)→$(tput sgr0)"

# options
VPN_MODE_MANUAL=""
VPN_OPTION_VERBOSE=""

# Help
function help() {
  local vpn="$(tput setaf 2)vpn.sh$(tput sgr0)"
  cat <<HELP_VPN
$vpn v${VERSION} -- Automate vpn connections using 'openconnect'

Usage:
  $vpn [hVsmvd]

Options:
  -h  Display this help message
  -V  Display the version number and exit
  -s  Display connection status and exit
  -m  Run manual mode
  -v  Verbose mode. Causes vpn to print debugging messages about its progress.
      This is helpful in debugging connection.
  -d  Disconnect VPN
HELP_VPN
}

# echo with prefix "echo".
function echo_info() {
  #echo -e " $(tput setaf 2)>>$(tput sgr0) $1"
  echo -e "$ECHO_PREFIX $1"
}

# echo with prefix "data".
function echo_data() {
  echo -e "$DATA_PREFIX $1"
}

function echo_success() {
  echo -e " $(tput setaf 2)✔︎ $(tput sgr0) $1"
}

function echo_error() {
  echo -e " $(tput setaf 1)✘ $(tput sgr0) $1"
}

function echo_loading() {
  echo -ne " ⏳\r"
}

# echo with status.
# @param $1 message if connected
# @param $2 message if disconnected
function echo_with_status() {
  pid=$(pgrep -f openconnect)
  if [ -z "$pid" ]; then
    echo_error "$2"
    return 1
  else
    echo_success "$1 (pid: ${pid})"
    return 0
  fi
}

# check sudo auth.
# @return sudo sucess is true(0), fail is exit
function check_sudo() {
  local can_i_run_sudo
  can_i_run_sudo=$(sudo -n uptime 2>&1 | grep -c "load")
  if [ "$can_i_run_sudo" -lt 1 ]; then
    echo_error "You are not authorized to run this VP (sudo password is incorrect)"
    exit 1
  fi
  return 0
}

# get yn from prompt.
# @return 'y' is true(0), 'n' or other is false(1)
function is_yn() {
  local tty_state yn
  echo -ne "$ECHO_PREFIX $1 [y/n]: "
  #printf "%s%s [y/n]: " "$ECHO_PREFIX" "$1"
  tty_state=$(stty -g)
  stty raw -echo
  yn=$(dd bs=1 count=1 2>/dev/null)
  stty "$tty_state"
  echo

  if [[ $yn =~ ^[y|Y]$ ]]; then
    return 0
  else
    return 1
  fi
}

# get vpn status detail.
# @return connection is 0, disconnection is 1
function status() {
  echo_with_status "VPN is connected" "VPN is connected"
  local vpn_status="$?"
  if [ $vpn_status -eq 0 ]; then
    local IFS
    local array
    IFS=' ' read -r -a array <<<"$(pgrep -lf openconnect)"

    echo -e " --------------------------------------"
    echo_info "openconnect"
    unset "array[0]"
    unset "array[1]"
    for i in "${array[@]}"; do
      echo -e "      ${i}"
    done
    return 0
  else
    return 1
  fi
}

# disconnect vpn.
# @return if vpn is not connect, exit sh
function disconnect() {
  if [ "$(pgrep -f "openconnect" | wc -l)" -gt 0 ]; then
    echo_info "Disconnecting..." && echo_loading
    sudo pkill -SIGINT openconnect >/dev/null 2>&1
    sleep 1s
  else
    echo_error "Not connected to VPN."
    exit 0
  fi
}

# connect vpn.
# if name or url is empty, exit
# @param user
# @param url
function connect() {
  local user url

  # check process of openconnect
  local pid
  pid=$(pgrep -f "openconnect")
  if [ -n "$pid" ]; then
    echo_info "VPN is already connected: $pid"
    if is_yn "Do you want reconnecting VPN?"; then
      disconnect
    else
      echo_error "Cancel"
      exit 1
    fi
  fi

  # get login info by user
  if [ ${VPN_MODE_MANUAL:-0} -eq 1 ]; then
    echo_info "If user/url isn't entered, set default values."
    echo_data "User: $(tput setaf 7)$USER$(tput sgr0)"
    echo_data "Url : $(tput setaf 7)$SERVER$(tput sgr0)"
    echo_info "Please enter $(tput smul)user$(tput rmul)."
    read -rp "$DATA_PREFIX " user
    echo_info "Please enter $(tput smul)url$(tput rmul)."
    read -rp "$DATA_PREFIX " url
  else
    echo_data "User: $(tput setaf 7)$USER$(tput sgr0)"
    echo_data "Url : $(tput setaf 7)$SERVER$(tput sgr0)"
  fi

  # set redirect
  local redirect=/dev/null
  if [ $VPN_OPTION_VERBOSE ]; then
    redirect=/dev/tty
  fi

  # connect
  if [ ${VPN_MODE_MANUAL:-0} -eq 0 ]; then
    echo_info "Connecting..." && echo_loading
    (eval "$PASSWORD" && eval "$PASSWORD_SECOND") | sudo openconnect \
      --background \
      --juniper \
      --user="${user:-$USER}" \
      --useragent="ua" \
      "${url:-$SERVER}" \
      ${VPN_OPTION_VERBOSE:+--verbose} \
      &>$redirect
  else
    sudo openconnect \
      --background \
      --juniper \
      --user="${user:-$USER}" \
      --useragent="ua" \
      "${url:-$SERVER}" \
      ${VPN_OPTION_VERBOSE:+--verbose} \
      >$redirect
  fi

  return 0
}

#------------------------------------------------------------------------------
# main function
function main() {

  # pasing options
  local OPTIND
  local allow_options="hsdmvV"
  local do_connect=1
  while getopts "${allow_options}" option; do
    case $option in
    h)
      help
      exit 0
      ;;
    V)
      echo_info "vpn.sh version v${VERSION}"
      exit 0
      ;;
    s)
      status
      exit $?
      ;;
    d)
      do_connect=0
      ;;
    m) VPN_MODE_MANUAL=1 ;;
    v) VPN_OPTION_VERBOSE=1 ;;
    \?)
      echo "Usage: vpn.sh [-${allow_options}]" >&2
      exit 1
      ;;
    esac
  done

  sudo echo "$(tput bold)$(tput setaf 7) 🔐  Hello VPN!$(tput sgr0)"
  check_sudo

  if [ "${do_connect}" -eq 1 ]; then
    connect
    sleep 1.5s # delay
    echo_with_status "VPN connection has succeeded." "VPN connection has failed."
  else
    disconnect
    echo_info "Done."
  fi

  return $?
}

#------------------------------------------------------------------------------
# Run vpn command.
#------------------------------------------------------------------------------

# handling interrupt from keyboadrd(Ctrl+C)
function trap_interrupt() {
  echo
  echo_error "Exit VPN"
  exit 1
}
trap trap_interrupt INT

main "$@"
exit 0
