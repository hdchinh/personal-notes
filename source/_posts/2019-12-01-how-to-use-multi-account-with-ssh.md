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


## 2. Add key

eg.
```bash
ssh-add ~/.ssh/primary_github
```

## 3. Cache

Remove cache:
```bash
ssh-add -D
```

Show cache:
```bash
ssh-add -l
```

## 4. Create config file

eg.

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
