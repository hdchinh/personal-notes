---
title: "A Simple ORM"
date: 2019-06-26
draft: false
tags: ["orm", "ruby"]
categories: ["rails notes"]
mytag: "Ruby"
mytrend: "COOL"
# mytop: "TOP VIEWS"
---

# 1. Đặt vấn đề

Rails có phải là một framework tuyệt vời hay không? Chắc chắn là có rồi, với tôi là như vậy, mặc dù nó tốn Ram quá nhiều và chạy cũng hơi chậm, mọi thứ khác thật sự tuyệt vời.

Nếu cần phải xây dựng một ứng dụng CRUD, có lẽ Rails sẽ là một lựa chọn hàng đầu, vì thời gian xây dựng nhanh chóng để cho ra một sản phẩm tuy không phải là "ích seo lừn" nhưng cũng đủ good để work production.

Một trong những yếu tố làm cho Rails xây dựng các ứng dụng một cách nhanh chóng như vậy chính là gem ActiveRecord, một ORM mặc định và vô cùng mạnh mẽ trong Rails.

Như nhiều người khác, khi mới tiếp cận Framework này, tôi cũng sử dụng các lệnh command, các phương thức được support mà cũng không quan tâm đến cách mà nó vận hành.

Nhưng nghĩ đi nghĩ lại thấy cũng kì, làm mà không hiểu kì cục lắm :smile:

Vậy thôi, chúng ta hãy cùng thử xây dựng một ORM rất đơn giản, để coi thử magic gì đã xảy ra sau mỗi dòng lệnh.

# 2. Mã nguồn

> Mã nguồn của ứng dụng này, bạn có thể tham khảo [tại đây](https://github.com/hdchinh/simple-orm-ruby)

# 3. Giải thích

Note: Trước hết chúng ta nên đọc trước về định nghĩa của ORM [tại đây](https://en.wikipedia.org/wiki/Object-relational_mapping)

Để xây dựng 1 ORM và chạy một vài ví dụ đơn giản được thì chúng ta có 2 nhiềm vụ phải làm:

- Kết nối với cơ sở dữ liệu (ở đây là postgresql).

- Xây dựng các class bằng Ruby với các phương thức tương ứng để xử lý trên cơ sở dữ liệu đã kết nối ở bước 1.

**STEP 1: Tạo project**

Tạo một project trống với 1 file Gemfile có nội dung như sau:

```ruby
source 'https://rubygems.org'

gem 'pg'
```

Cài đặt gem bằng lệnh: `bundle install`.

Nếu có lỗi xảy ra hãy tham khảo các tài liệu về cài đặt và sử dụng gem bundler.

**STEP 2: Kết nối cơ sở dữ liệu.**

Khi bắt đầu và quen thuộc với việc sử dụng command trong rails, việc duy nhất chúng ta còn thực sự sử dụng đó là sửa file `database.yml`, và đó là tất cả những gì cần thiết để đem ứng dụng của chúng ta kết nối với 1 hệ quản trị cơ sở dữ liệu nào đó trên máy. (Thực ra là vẫn còn nhiều điều xảy ra lắm, nhưng hãy cứ tạm chấp nhận như vậy).

Nhưng nếu không sử dụng Framework Rails, trong trường hợp này, khi tôi kết nối với Postgresql thì tôi sẽ sử dụng một gem tên `pg` đã cài đặt ở bước 1, và require nó vào file `connection.rb` có tác dụng kết nối như sau:

```ruby
require 'pg'

$conn = PG::Connection.connect(
  :hostaddr=>"127.0.0.1", :port=>5432,
  :dbname=>"test-psql_development",
  :user=>"admin",
  :password=>''
)
```
Note: Bạn cần thay đổi các giá trị ở trên để phù hợp với database mà bạn muốn kết nối trên máy của bạn.

Lúc này project của chúng ta có cấu trúc:

```
-- simple-orm
  -- Gemfile
  -- Gemfile.lock (sinh ra sau lệnh `bundle install`)
  -- connection.rb
```

Note: Trong file `connection.rb` tôi khai báo biến conn dưới dạng biến toàn cục, để dễ ràng require trong các file khác trong project.

**STEP 3: Xây dựng Class chứa chức năng chính.**

Tạo file `mybase.rb` với nội dung như sau:

```ruby
require_relative 'connection.rb'

class MyBase
  def self.all
    term = "SELECT * FROM #{self.name.downcase}"
    res = $conn.exec(term)

    res.each{ |row|
      puts "#{row}\n"
    }
  end

  def self.find(id)
    term = "SELECT * FROM #{self.name.downcase} where id = #{id}"
    res = $conn.exec(term)

    res.each{ |row|
      puts "#{row}\n"
    }
  end
end
```

require file `connection.rb` vào để sử dụng biến conn.

Trong class này xây dựng 2 class method là `all` và `find`, ứng với 2 phương thức trong ActiveRecord.

`all`: Trả về toàn bộ record trong table.
`find`: Trả về record ứng với id được truyền vào.

**STEP 4: Xây dựng class con kế thừa lớp Base ở bước 3 và sử dụng**

Trong cơ sở dữ liệu mà tôi kết nối có table tên `comics`. Tôi tạo file comics.rb có nội dung như sau:

```ruby
require_relative 'mybase.rb'

class Comics < MyBase; end

puts "All record in comics table:\n"
Comics.all
puts "Find record has id is 6:\n"
Comics.find(6)
```

- Tôi require file `mybase.rb` đã viết ở bước 3 vào file này.

- Tạo class `Comics` và cho nó kế thừa class `MyBase`

- In ra màn hình console các dòng lệnh đã xây dựng để xem kết quả (với lệnh `ruby  comics.rb` ta sẽ chạy file comics.rb và xuất kết quả ra màn hình console).


Cuối cùng project của chúng ta có dạng như sau:

```
-- simple-orm
  -- Gemfile
  -- Gemfile.lock (sinh ra sau lệnh `bundle install`)
  -- connection.rb
  -- mybase.rb (main chính chứa các phương thức)
  -- comics.rb (class ứng với table comics trong csdl, kế thừa MyBase)
```

Chạy file `comics.rb` với lệnh chạy ruby `ruby comics.rb` ta sẽ xem được thành quả nhỏ của quá trình xây dựng kể trên.

# 4. Kết luận

Trên là một ví dụ đơn giản về ORM với ngôn ngữ Ruby, các ORM trong thực tế sẽ phức tạp và tinh tế hơn rất rất nhiều. Hy vọng qua bài viết sẽ giúp bạn đọc có được thêm kiến thức với ORM và cách nó vận hành trong framework như Rails.
