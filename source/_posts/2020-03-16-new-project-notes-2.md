---
title: "New Project Notes 2"
date: 2020-03-16
tags: ["NOTES"]
label: "[#notes]"
---

## 1. Install homebrew formula

When you install a new homebrew formula, homebrew will update all formula as default option. In almost case, it's no problem. But, if you'd like to install new formula without update current formula, try:

```
HOMEBREW_NO_AUTO_UPDATE=1 brew install <formula>
```

## 2. Why you need run "bundle exec"

You have installed rspec for your project. sometime you run **rspec** and everything work well, but sometimes it does not, it required you type **bundle exec rspec**.

The short explain, when you have more than one version of gem (eg. rspec), you need type **bundle exec** to tell rails use the version in Gemfile (Gemfile.lock)
