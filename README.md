# VPN

> automation connect vpn

## Dependency or Recommand modules

- [openconnect](http://www.infradead.org/openconnect/): vpn client
- gpg
- [pass](https://www.passwordstore.org/): the standard unix password manager
 
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
<summary>Tip. Using <code>pass</code></summary>

```bash
$ gpg --gen-key
$ pass init "password stroe"
# Add password for vpn
$ pass insert vpn/login-password
# Add password of mail for OTP
$ pass insert email/gmail
```

</details>

## Usage

```bash
./vpn.sh -h
```

<details>
<summary>Tip. <code>alias</code> setting</summary>

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
