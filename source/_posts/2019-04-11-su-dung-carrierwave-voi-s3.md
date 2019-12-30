---
title: "Sử Dụng Carrierwave Với S3"
date: 2019-04-11
draft: false
tags: ["rails", "aws", "carrierwave", "til"]
categories: ["rails notes"]
mytag: "#TIL"
label: "[@til]"
---

# Gemfile

```ruby
gem 'fog', require: 'fog/aws'
gem 'carrierwave'
```
# Class Uploader

```ruby
storage :fog
```

# File cấu hình config/initializers/carrierwave.rb

```ruby
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider              => 'AWS',
    :aws_access_key_id     => Rails.application.credentials.access_key_id,
    :aws_secret_access_key => Rails.application.credentials.secret_access_key,
    :region                => Rails.application.credentials.s3_region,
    :path_style            => true,
    :host                  => 's3.us-east-2.amazonaws.com',
    :endpoint              => 'https://s3.us-east-2.amazonaws.com'
  }
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory  = Rails.application.credentials.s3_bucket
  config.fog_public     = true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{10.day.to_i}" }
  config.storage = :fog
end
```

# Acess File uploaded

`Instance.field_name_image.url` (get link s3)

# Source demo

[Tại đây](https://github.com/hdchinh/s3_carrierwave)
