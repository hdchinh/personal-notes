---
title: Custom Heroku domain
date: 2022-09-12
---

1. Custom domain

```
heroku domains:add coolname.com --app <HEROKU APP NAME>
```

2. Go to domain register service

Add DNS records: ALIAS - @ - DNS endpoint

3. Make sure you go through Heroku app settings to enable SSL, by default it will be disable by Heroku

4. Wait a few minutes

[https://devcenter.heroku.com/articles/custom-domains](https://devcenter.heroku.com/articles/custom-domains)
[https://www.youtube.com/watch?v=UBpJV156jzk](https://www.youtube.com/watch?v=UBpJV156jzk)
