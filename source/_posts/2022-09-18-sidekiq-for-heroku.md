---
title: Sidekiq For Heroku
date: 2022-09-18
---

1. Version incompatible

The latest version of Redis gem makes quite much issues, the easiest way to deal with it is downgrade Redis gem version:

```
gem 'redis', '< 4.6'
```

And update this dependencies by:

```
bundle update
```

2. Config sidekiq

```ruby
# config/initializers/sidekiq.rb

Sidekiq.configure_server do |config|
  config.redis = { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
end

Sidekiq.configure_client do |config|
  config.redis = { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
end
```

Note: **verify_mode: OpenSSL::SSL::VERIFY_NONE** is a must to make it works with Heroku

```ruby
# Custom sidekiq default settings: config/sidekiq.yml

concurrency: 5
max_retries: 3
```

4. Update Procfile

```bash
worker: bundle exec sidekiq -c 2
```

5. Enable worker in the Heroku dashboard, by the default it was disable

6. Check worker log

```bash
heroku logs --t --app APP_NAME --dyno worker
```
