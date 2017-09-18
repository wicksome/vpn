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

# Unexpected 400 result from server...

**Error message**

```
Got HTTP response: HTTP/1.1 400 Bad Request
Unexpected 400 result from server
Creating SSL connection failed
```

**Solution**

https://bugs.archlinux.org/task/50869
