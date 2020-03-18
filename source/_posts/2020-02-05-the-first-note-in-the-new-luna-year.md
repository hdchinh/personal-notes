---
title: "New Project Notes [Part 1]"
date: 2020-02-05
tags: ["NOTES"]
label: "[#notes]"
---

## 1. Rbenv does not show all version ruby.

- Reseaon: ruby-build outdated
- Solution: update ruby-build

Find ruby-build folder and pull the latest code, just type **git pull** (it is a repository).

## 2. Apply bootstrap for rails 6

- step 1: **yarn add bootstrap jquery popper.js**

- step 2: add the code below to **config/webpack/environment.js**

```js
const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}))

module.exports = environment
```

- step 3: add to **app/javascript/packs/application.js**
require("bootstrap/dist/js/bootstrap")

- step 4: add to **app/assets/stylesheets/application.css**
@import "bootstrap/scss/bootstrap";

## 3. Apply git ignore to committed files

- step 1: edit **.gitignore**
- step 2: **git rm --cached /path/to/file* or *git rm --cached -r /path/to/folder**

## 4. Rename both local and remote branch

- step 1: rename local branch **git branch -m new-name**
- step 2: delete old remote branch **git push origin :old-name new-name**
- step 3: update for the new romote branch **git push origin -u new-name**

## 5. References

[1][https://gorails.com/forum/install-bootstrap-with-webpack-with-rails-6-beta](https://gorails.com/forum/install-bootstrap-with-webpack-with-rails-6-beta)

[2][https://stackoverflow.com/questions/7527982/applying-gitignore-to-committed-files](https://stackoverflow.com/questions/7527982/applying-gitignore-to-committed-files)

[3][https://linuxize.com/post/how-to-create-mysql-user-accounts-and-grant-privileges/](https://linuxize.com/post/how-to-create-mysql-user-accounts-and-grant-privileges/)

[4][https://multiplestates.wordpress.com/2015/02/05/rename-a-local-and-remote-branch-in-git/](https://multiplestates.wordpress.com/2015/02/05/rename-a-local-and-remote-branch-in-git/)
