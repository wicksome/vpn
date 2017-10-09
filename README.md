<p align="center">
 <h1><b>VPN.sh</b></h1>
 <p>Automate VPN connection.</p>
 <img src ="https://user-images.githubusercontent.com/5036939/31331536-a8fa2ea2-ad1d-11e7-88b0-5a88f8eabca2.png" />
</p>

## Dependency

- Python 2.x
- [openconnect](http://www.infradead.org/openconnect/) v7.0.8: vpn client
 
## Install

1. Clone vpn repository: `$ git clone <repo-url>`
2. Run install script: `$./install.sh`
3. Setting `.vpnrc` file: `$ cd $HOME && vi .vpnrc`

    ```bash
    #!/bin/bash
    VPN_STR_USER="yeongjun.kim"
    VPN_STR_SERVER="url of vpn server"
    VPN_CMD_PASSWORD="echo 'pw12345'"
    VPN_STR_IMAP="imap.gmail.com"
    VPN_STR_MAIL_ID="mail id"
    VPN_CMD_MAIL_PASSWORD="pass email/gmail" # using pass
    VPN_STR_KEYWORD_OF_MAIL_TITLE_FOR_SEARCH="OTP number"
    VPN_REGEX_FOR_GETTING_PASSWORD_TO_MAIL_CONTENT="OTP number: \[([0-9]{6})\]"
    ```

<details>
<summary>Recommand. Using <code>pass</code></summary>

> I recommand you that use `pass` module for manage passwords.

- gpg
- [pass](https://www.passwordstore.org/): the standard unix password manager

**install & setting**

Installation and initialization

```bash
$ brew install gpg
$ brew install pass
$ gpg --gen-key
$ pass init "password stroe"
$ pass insert vpn/login-password # Add password for vpn
$ pass insert email/gmail        # Add password of mail for OTP
```

Then, modify part that set the password in `.vpnrc`

```sh
VPN_CMD_PASSWORD="pass vpn/login-password"
VPN_CMD_MAIL_PASSWORD="pass email/gmail"
```

</details>

## Usage

<details>
<summary>Recommand. <code>alias</code> vpn</summary>

Add alias to your shell config(bashrc, zshrc, ...) 

```bash
alias vpn="~/your-vpn-path/vpn"
```

</details>


### VPN Help

```bash
$ vpn -h
vpn.sh v1.0.0 -- Automate vpn connections using 'openconnect'

Usage:
  vpn.sh [hVsmvd]

Options:
  -h  Display this help message
  -V  Display the version number and exit
  -s  Display connection status and exit
  -m  Run manual mode
  -v  Verbose mode. Causes vpn to print debugging messages about its progress.
      This is helpful in debugging connection.
  -d  Disconnect VPN
```


### VPN Connection

![demo](https://user-images.githubusercontent.com/5036939/31331491-75aae5d2-ad1d-11e7-9b28-17f3c1c44d95.gif)

```bash
$ vpn
 🔐  Hello VPN!
  → User: yeongjun.kim
  → Url : https://test-server-url.com
 >> Connecting...
 ✔︎  VPN connection has succeeded. (pid: 31379)

# Manual mode
$ vpn -m
# Manual mode and Verbose Mode
$ vpn -mv
```

<details>
<summary>screenshot</summary>

![vpn auto-connection](https://user-images.githubusercontent.com/5036939/29922226-aae38940-8e8f-11e7-8de7-1b3cbdb787d0.png)

</details>

### VPN Disconnection

```bash
$ vpn -d
Password:
 🔐  Hello VPN!
 >> Disconnecting...
 >> Done.
```

<details>
<summary>screenshot</summary>

![vpn disconnection](https://user-images.githubusercontent.com/5036939/29922354-368226d2-8e90-11e7-97f1-a83c23bbfd6a.png)

</details>

### VPN status

```bash
# if connected VPN
$ vpn -s
 ✔︎  VPN is connected (pid: 99901)
 --------------------------------------
 >> openconnect
      --background
      --juniper
      --user=yeongjun.kim
      --useragent=ua
      https://test-server-url.com
      
# if disconnected VPN
$ vpn -s
 ✘  VPN is connected
```

<details>
<summary>screenshot</summary>

![conntection status](https://user-images.githubusercontent.com/5036939/29922328-2375cc56-8e90-11e7-955d-393b4ce2cfab.png)

![disconntection status](https://user-images.githubusercontent.com/5036939/29922481-c4d8c94a-8e90-11e7-93a5-62deb6053759.png)

</details>


### VPN version

```bash
$ vpn -V
 >> vpn.sh version v1.0.0
```

## [Troubleshooting](./troubleshooting.md)

## [License](./LICENSE.md)
