---
title: Upgrade Heroku-postgres Plan
date: 2022-09-18
---

1. Enable maintenance mode

2. Add new plan

```bash
heroku addons:create heroku-postgresql:hobby-basic --app APP_NAME
```

3. Copy data from current db to the new one

```bash
heroku pg:copy DATABASE_URL HEROKU_POSTGRESQL_CYAN_URL --app APP_NAME
```

Note: `DATABASE_URL` and `HEROKU_POSTGRESQL_CYAN_URL` are heroku ENVs, run `heroku config` to check the detail.

4. Select the new db as the default database

```bash
heroku pg:promote HEROKU_POSTGRESQL_CYAN_URL --app APP_NAME
```
