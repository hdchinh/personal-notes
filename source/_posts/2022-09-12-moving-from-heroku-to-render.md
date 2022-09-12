---
title: Moving from Heroku to Render
date: 2022-09-12
---

1. Deploy rails app to Render

[https://render.com/docs/deploy-rails](https://render.com/docs/deploy-rails)

```yaml
databases:
  - name: hocthoi_api
    databaseName: hocthoi_api
    user: hocthoi_api
    plan: free

services:
  - type: web
    name: hocthoi_api
    env: ruby
    plan: free
    autoDeploy: true
    buildCommand: "./bin/render-build.sh"
    startCommand: "bundle exec puma -C config/puma.rb"
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: hocthoi_api
          property: connectionString
      - key: RAILS_MASTER_KEY
        sync: false

```

Re-generate master.key if needed.

2. Export database from Heroku

[https://render.com/docs/migrate-from-heroku](https://render.com/docs/migrate-from-heroku)

```
heroku pg:backups:capture --app <HEROKU APP NAME>
```

```
heroku pg:backups:download --app <HEROKU APP NAME>
```

```
pg_restore --clean --verbose  --no-acl --no-owner -d <EXTERNAL CONNECTION STRING> latest.dump
```

Add --clean flag to override table if needed.
