---
title: "Cơ Chế Autoloading Và Reloading"
date: 2019-04-17
draft: false
tags: ["rails"]
categories: ["rails notes"]
mytag: "#TIL"
---

# Đặt vấn đề

```ruby
class CatsController < ApplicationController
  # do something
end
```

Đoạn mã trên là một đoạn mã rất quen thuộc khi sử dụng rails framework, một câu hỏi đó là tại sao trong class CatsController không require file chưa class ApplicationController nhưng ta vẫn có thể sử dụng. Câu trả lời nằm ở việc rails có cơ chế autoloading một số folder nhất định để support cho việc coding và vận hành, bài viết này sẽ nêu một cách khái quát về giải pháp này trong rails.

# Luận bàn

Như bài viết trước đã đề cập về cách mà phương thức require hoạt động:

1. Tìm file được require theo các đường dẫn được lưu trong biến $LOAD_PATH (biến này là 1 mảng các đường dẫn).

2. Khi tìm được file tương ứng thì dừng quá trình tìm file và bắt đầu load file tìm được vào bộ nhớ.

3. Nếu tìm hết các đường dẫn và không thấy thì gọi tới LoadError.

**autoload_paths** là một tập hợp các thư mục được tự động load mà không cần require. Mặc định thì autoload_paths sẽ chứa các thư mục sau:

1. Tất cả các thư mục con cấp 1 của thư mục app, ví dụ như app/controllers, app/views...

2. Tất cả các thư mục cấp 2 tên là concerns trong app, ví dụ như app/helpers/concerns, app/lib/concerns...

3. Thư mục test/mailers/previews.

Ta có thể xem danh sách này bằng câu lệnh:

`bin/rails r 'puts ActiveSupport::Dependencies.autoload_paths'`

**eager_load_paths** hoàn toàn giống như khái niệm về autoload_paths đã nêu ở trên. Điểm chúng ta cần lưu ý đó là:

1. Những thư mục nằm trong eager_load_paths sẽ được load một lần duy nhất TRƯỚC khi ứng dụng của bạn khởi chạy.

2. Những thư mục nằm trong autoload_paths sẽ được sử dụng để tìm kiếm khi chương trình ĐANG CHẠY và gặp 1 từ khoá chưa được định nghĩa trong file hiện tại.

Ta có 2 từ in hoa, đó là phần quan trọng, để đảm bảo tính nhất quán và hoạt động một cách ổn định và chính xác, trong môi trường production ta sử dụng eager_load_paths để load toàn bộ những file cần thiết cho các hệ thống cần thì sử dụng, còn ở môi trường phát triển, để khởi chạy ứng dụng nhanh chóng hơn và dễ dàng cập nhật các thay đổi thì ta sử dụng autoload_paths.

Việc thiết lập này phụ thuộc vào cấu hình của bạn trong thư mục `app/config/envirements/...` với 2 cấu hình là:

- config.cache_classes

- config.eager_load

# Kết luận

Tham khảo:

[1] [autoloading_and_reloading_constants](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html)
