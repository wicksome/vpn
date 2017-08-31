# Auto VPN

> Automate VPN connection.

![preview-help](https://user-images.githubusercontent.com/5036939/29917591-6819abba-8e7d-11e7-855e-76a2a7271bc2.png)

## Dependency

- Python 2.x
- [openconnect](http://www.infradead.org/openconnect/): vpn client
 
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

Recommand you that use `pass` module for manage passwords.

- gpg
- [pass](https://www.passwordstore.org/): the standard unix password manager

```bash
$ brew install gpg
$ brew install pass
$ gpg --gen-key
$ pass init "password stroe"
$ pass insert vpn/login-password # Add password for vpn
$ pass insert email/gmail # Add password of mail for OTP
```

</details>

## Usage

```bash
./vpn.sh -h
```

<details>
<summary>Recommand. <code>alias</code> setting</summary>

1. Add alias to your shell config(bashrc, zshrc, ...) 

    ```bash
    alias vpn="~/your-vpn-path/vpn.sh"
    ```

2. easy run

    ```bash
    $ vpn
    ```

</details>

## Troubleshooting

### Error: The \`brew link\` step ...

**Error message**

```bash
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink share/man/man8/openconnect.8
/usr/local/share/man/man8 is not writable.
```

**Solution**

```bash
sudo chown -R $(whoami) /usr/local/share/man/man8
brew link openconnect
```
