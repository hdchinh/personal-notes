---
title: Use multiple accounts with SSH
date: 2019-12-01
tags: ["TIL"]
---

## 1. Generate keys

```bash
ssh-keygen -t rsa -C "YOUr_EMAIL_OR_YOUR_INFO" -f "YOUR_NAME_YOU_WANT_TO_SET_FOR_THIS_KEY"
```

eg.
```bash
ssh-keygen -t rsa -C "hduychinh@gmail.com" -f "primary_github"
```


## 2. Add key to ssh-agent

eg.
```bash
ssh-add ~/.ssh/your_file_ssh
```

what is ssh-agent?

eazy way, we can think it like a stack. When you access to server with ssh connection type.
So your device will send this stack to server. And if the valid key (private key) stored in this stack, you can access to server.

If you use ssh-agent. You can access like this:

```bash
ssh ubuntu@123.456.789
```

instead of:

```bash
ssh -i ~/.ssh/your_valid_private_key ubuntu@123.456.789
```

## 3. ssh-agent

Remove all entries in ssh-agent:
```bash
ssh-add -D
```

Show all entries in ssh-agent:
```bash
ssh-add -l
```

## 4. Create config file

> ~/.ssh/config

eg:

```
Host primary_github.github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/primary_github

Host secondary_github.github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/secondary_github
```
## 5. Add remote with prefix

eg:
```bash
git remote add origin git@primary_github.github.com:1312047/nus-overview.git
```
