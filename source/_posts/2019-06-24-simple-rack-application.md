---
title: "A Simple Rack Application"
date: 2019-06-24
draft: false
tags: ["RACK", "RUBY"]
categories: ["RUBY"]
---

# 1. Đặt vấn đề
Có lẽ cũng như tôi, khi mới tiếp cận với một framework ruby như Rails chẳng hạn, bạn đã nghe về Rack? hoặc ít ra cũng từng thấy cái `gem rack` trong Gemfile. Nhưng có khi nào bạn dùng đến chúng? Không ư? Tôi cũng nghĩ vậy, tôi cũng kệ, tôi cũng chả quan tâm, cuộc sống không đủ high hay sao mà lại đâm đầu vào cái khó :alien:.

Nhưng làm việc hàng ngày với nó mà không hiểu nó là gì luôn làm cho ta cảm giác bất an vô định, cập nhật CV là Developer mà đi phỏng vấn được hỏi rack là gì, lại trả lời "em...em..em hông biết" thì liệu có bị đánh xuống rank junior hay không? Thôi thì cứ tìm hiểu coi nó ra sao.

Và thế là tôi đã đọc docs trên trang chủ của Rack, nói chung đọc qua thì có hiểu, mà cái hiểu nó mông lung như một trò đùa, chút nữa thì đành phải "anh xin giơ tay rút lui thôi".

Vậy nên tôi sẽ viết một ứng dụng Rack (chạy trên Rack) very..very simple, để tôi và có thể cả bạn có cái nhìn thoáng qua về Rack trước đã, chứ tôi thấy hiểu biết hiện tại của mình chưa đủ để chém gió hàn lâm về chủ đề này (hy vọng tương lai gần sẽ có bài chém gió hàn lâm).

# 2. Tham khảo?

1. Bài viết này tôi tham khảo cách sử dụng Rack trên trang chủ của Rack [tại đây](https://rack.github.io/) và trên mục docs của ruby [tại đây](https://www.rubydoc.info/github/rack/rack/).

2. Ứng dụng rất thô sơ và KHÔNG sử dụng "bét pờ rạch tít" nào cả.


# 3. Kiến thức cần chuẩn bị trước.

Dù ít dù nhiều thì vẫn phải đánh qua lý thuyết một chút trước khi mày mò làm gì đó. Một số khái niệm/quy trình chúng ta nên nắm trước như sau:

1) Rack là một lớp nằm giữa web/app server và ứng dụng.

Ex: Nếu tôi sử dụng Rails với app server là Puma, web server là Nginx thì đường đi của một request sẽ như sau:

![hoa](/images/rack.jpeg)

Note: Khái niệm `web server` và `app server` chúng ta sẽ bàn tới sau.

2) Như hình trên, ta có thể thấy Rack sẽ giao tiếp với `app server`, nên Rack sẽ nhận request từ app server gửi qua, với nội dung lằng nhằng rối rắm gì đó, sau đó Rack sẽ `làm gì đó` với cái request rối rắm kia, rồi gửi kết quả mà Rails có thể hiểu và thực thi được. Sau đó Rails sẽ gửi về cho Rack kết quả cũng rối rắm không kém và nhiệm vụ của Rack lại là tiếp tục `làm gì đó` cái kết quả từ Rails, sao cho chuyển kết quả đó thành 1 thứ gì đó mà app server có thể hiểu, cuối cùng app server quăng kết quả về cho người dùng.

Note: Vậy Rack như một phiên dịch viên để truyền đạt giữa ứng dụng và app server (Không thật sự đúng về bản chất nhưng ta cứ tạm chấp nhận liên tưởng này).

# 4. Build một simple Rack application

- Tạo 1 Folder với 1 file tên `Gemfile` có nội dung như sau:

```ruby
source 'https://rubygems.org'

gem 'rack'
```

- Cài đặt gem vói lệnh `bundle install`

- Tạo file `config.ru`.

Note: Đây sẽ là file main để xử lý request.

- Chạy project với lệnh `bundle exec rackup`

> Project demo [tại đây!](https://github.com/hdchinh/simple-rack-app)

# 5. Giải thích nội dung mã nguồn của app demo

```ruby
map '/signup_user' do
  run SignUpUser.new
end

map '/signup' do
  run MySignUp.new
end

map '/signin' do
  run MySignIn.new
end

map '/signin_user' do
  run SignInUser.new
end

map '/' do
  run HomePage.new
end

run MyNotFound.new
```

Chắc bạn cũng có thể đoán ra ý nghĩa của nó, nếu map chúng đường dẫn thì sẽ chạy lệnh trong đó.

Ex:

```ruby
map '/' do
  run HomePage.new
end
```

Nếu truy cập theo trang chủ thì sẽ chạy lệnh `run HomePage.new`.

Nếu url người dùng request không trùng bất cứ trường hợp nào thì chạy lệnh `run MyNotFound.new` ở cuối.

Một class sẽ có dạng như sau:

```ruby
class SignInUser
  def call(env)
    # read file data
    file = File.read('data.txt')

    # get params
    data =  Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    email = data['email']
    pass = data['password']

    # convert file data from string to hash
    hash_data = eval(file)
    # init variable for user login
    user_email = nil

    # loop hash to find email params
    hash_data.each do |k, val|
      if k == email
        if val = pass
          user_email = k
        end
      end
    end

    if user_email
      body = ["<h1>email: #{user_email}<h/1>"]
    else
      body = ["<h1>Email or Password Invalid</h1>"]
    end

    [200, {'Content-Type' => 'text/html'}, body]
  end
end
```

Bạn thấy phức tạp? Không sao cả, chỉ cần chú ý đến dòng cuối cùng trong method call. Ta chỉ cần nhớ:

- Mỗi class sử dụng method call để cài đặt (yêu cầu của Rack).

- Trong method này nhận vào một params, đây chính là request đi tới.

- Kết quả trả về của method call này là một mảng gồm 3 phần tử:

  1. Status code (Ví dụ như: 200 -> success, 404 -> not found).
  2. Một hash, ở đây chính là header, chứa những thông tin mà trình duyệt cần.
  3. Phần tử cuối cùng là một mảng, chính là phần body của kết quả trả về.

# 6. Kết luận

Trên là một basic app xây dựng với Rack, vì định nghĩa chỉ đọc không làm sẽ rất khó hiểu, nên tôi làm demo trước, hy vọng trong thời gian tới nếu kiến thức thu lượm đủ để viết về cách vận hành của Rack một cách sâu sắc, tôi có thể tiếp tục chủ đề này.
