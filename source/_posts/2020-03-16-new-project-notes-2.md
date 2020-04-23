---
title: "New Project Notes [Part 2]"
date: 2020-03-16
tags: ["NOTES"]
label: "[#note]"
---

## 1. Install homebrew formula

When you install a new homebrew formula, homebrew will update all formula as default option. In almost case, it's no problem. But, if you'd like to install new formula without update current formula, try:

```
HOMEBREW_NO_AUTO_UPDATE=1 brew install <formula>
```

## 2. Why you need run "bundle exec"

You have installed rspec for your project. sometime you run **rspec** and everything work well, but sometimes it does not, it required you type **bundle exec rspec**.

The short explain, when you have more than one version of gem (eg. rspec), you need type **bundle exec** to tell rails use the version in Gemfile (Gemfile.lock)


## 3. Install the older version mysql in macos with homebrew

Today, I have a crazy problem with our project that we are working on. The one f**king lib in this project need mysql 5.7

But, remember, when you copy paste from go rails to install ruby, rails and related databases, we always install the lastest version of all, :D

So what? Let quick check mysql version on my machine...

Oh, shit, above 8.0.

Ok, no worry, just google "how to install another mysql version with homebrew" and then I take 3 hours to install, remove, run command which I have no idea what it doing for....and still  get error, error and error again. I'm sad, I lost my hope about my carrer :(

And finally, I try to install mysql 5.7

1. Remove mysql current version
```
brew uninstall mysql
```

2. Remove mysql version 5.7
```
brew uninstall mysql@5.7
```

3. Remove folder config mysql
```
rm -rf /usr/local/var/mysql
```

4. Remove config file
```
rm /usr/local/etc/my.cnf
```

5. Reinstall mysql version 5.7
```
rm /usr/local/etc/my.cnf
```

6. Manually link to mysql 5.7 because it's not latest version so home brew will do nothing

```
brew link --force mysql@5.7
```

7. Start mysql 5.7
```
brew services start mysql@5.7
```

8. Important note
When you reinstall mysql with older version, in all projects that you used mysql, you need to **gem uninstall mysql2** and **bundle** to reinstall gems mysql2, if not, you will get error.

## 4. Ignore migration file check
```ruby
config.active_record.migration_error = false
```

Add above config to config file.(config/envirements/*.rb)

## 3. References

[1][https://stackoverflow.com/questions/6588674/what-does-bundle-exec-rake-mean](https://stackoverflow.com/questions/6588674/what-does-bundle-exec-rake-mean)

[2][https://medium.com/@at0dd/install-mysql-5-7-on-mac-os-mojave-cd07ec936034](https://medium.com/@at0dd/install-mysql-5-7-on-mac-os-mojave-cd07ec936034)
