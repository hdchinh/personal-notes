---
title: Speed up images processing with carrierwave
date: 2022-09-23
---

1. Compress images from Frontend side before submit via API

2. Use worker to create thumbnail, preview version of images if needed

E.g: Create thumbnail image from original image URL

```ruby
require "open-uri"
require "mini_magick"

class ImageOptimizerService
  def initialize(media_file_id)
    @media_file = MediaFile.find(media_file_id)
  end

  def perform
    content = open(@media_file.file_url)
    width = 100
    height = 100
    quality = 30

    img = MiniMagick::Image.read(content)
    w_original = img[:width].to_f
    h_original = img[:height].to_f

    # check proportions
    op_resize = w_original * height < h_original * width ? "#{width.to_i}x" : "x#{height.to_i}"

    img.combine_options do |i|
      i.resize(op_resize)
      i.gravity(:center)
      i.quality quality.to_s if quality.to_i > 1 && quality.to_i < 100
      i.crop "#{width.to_i}x#{height.to_i}+0+0!"
    end

    img.format("jpg")

    media_file = MediaFile.create(file: img)
  end
end
```

3. Use CloudFront

Create AWS CloudFront and get the CDN endpoint

```ruby
config.asset_host = "https://your_random_string.cloudfront.net"
```

4. Override default method

```ruby
def move_to_cache
  true
end

def move_to_store
  true
end
```
