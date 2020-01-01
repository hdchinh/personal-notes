---
title: "So Sánh Class Method Và Scope"
date: 2019-06-09
draft: false
tags: ["RUBY", "RAILS"]
categories: ["RAILS"]
---

Tôi có 1 scope:

```ruby
class Product < ActiveRecord::Base
  scope :is_active, -> { where is_active: true }
end

# Lấy các products có thuộc tính is_active là true.
```

Tôi có 1 class method:

```ruby
class Product < ActiveRecord::Base
  def self.is_active
    where is_active: true
  end
end
```

2 method này là hoàn toàn tương đương nhau, kết quả trả về cũng vậy. Bây giờ thử 1 ví dụ khác.

```ruby
class Product < ActiveRecord::Base
  # lấy các products đang active
  scope :is_active, -> { where is_active: true }
  # lấy các products có type bằng type được truyền vào scope, và đảm bảo type được truyền vào có giá trị
  scope :by_type, -> type { where type: type if type.present? }
end

```

Viết ví dụ trên dưới dạng Class Method:

```ruby
class Product < ActiveRecord::Base
  # lấy các products đang active
  def self.is_active
    where is_active: true
  end
  # lấy các products có type bằng type được truyền vào scope và đảm bảo type truyền vào có giá trị
  def self.by_type(type)
    where type: type if type.present?
  end
end
```

Tiến hành gọi liên tiếp Scope:

```ruby
Product.by_type(nil).is_active
# truyền vào type không hợp lệ, nhưng scope is_active vẫn work bình thường
```

Tiến hành gọi liên tiếp Class Method:

```ruby
Product.by_type(nil).is_active

# Trản về một error method is_active không được định nghĩa cho nil.
```

Ủa vậy chuyện này là sao? Tại sao Scope vẫn work bình thường trong khi Class Method lại bắn về một exception?

Đây chính là điểm khác biệt quan trọng của Scopy và Class Method.

Scope luôn luôn trả về một **ActiveRecord Relation**. Còn Class Method thì sao? Nếu bạn không cover trường hợp **nil/blank** thì nó sẽ văng về **nil/blank** như vậy không thể chạy Class Method phía sau, vì method đó không thể chạy **với nil/blank**.
