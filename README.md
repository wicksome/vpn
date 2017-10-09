# VPN.sh</b></h1>
> Automate VPN connection.

<p align="center">
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


### VPN Help: `-h`

```bash
$ vpn -h
```


### VPN Connection: `[default]`, `-m`, `-v`

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

### VPN Disconnection: `-d`

```bash
$ vpn -d
Password:
 🔐  Hello VPN!
 >> Disconnecting...
 >> Done.
```

### VPN status: `-s`

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

### VPN version: `-V`

```bash
$ vpn -V
 >> vpn.sh version v1.0.0
```

## [Troubleshooting](./troubleshooting.md)

## [License](./LICENSE.md)
