# The \`brew link\` step ...

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

# ~~~Unexpected 400 result from server...~~~

**Error message**

```
Got HTTP response: HTTP/1.1 400 Bad Request
Unexpected 400 result from server
Creating SSL connection failed
```

**Solution**

https://bugs.archlinux.org/task/50869

# xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: 

**Error message**

```bash
xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
Error: Failure while executing: git config --local --replace-all homebrew.analyticsmessage true
==> Upgrading 21 outdated packages, with result:
libtiff 4.0.9_2, coreutils 8.29, wget 1.19.4_1, mat 0.6.1, little-cms2 2.9, libpng 1.6.34, pygobject3 3.26.1, freetype 2.9, openjpeg 2.3.0, icu4c 60.2, glib 2.54.3, cairo 1.14.12, gobject-introspection 1.54.1_1, scala@2.10 2.10.7, nginx 1.13.9, openssl@1.1 1.1.0g_1, py2cairo 1.16.3, node 9.7.1_1, jpeg 9c, poppler 0.62.0, openssl 1.0.2n
```

**Solution**

```bash
$ xcode-select --install

```
