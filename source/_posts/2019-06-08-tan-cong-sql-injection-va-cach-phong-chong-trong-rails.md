---
title: "Tấn Công SQL Injection"
date: 2019-06-08
draft: false
tags: ["SECURE", "RAILS"]
categories: ["RAILS"]

---

# Đặt vấn đề

Trong project của bạn, đã bao giờ bạn sử dụng câu lệnh có dạng như:

```ruby
  Product.where("product_name = 'Meo con di lon ton' ")
```

Nếu có, thì bạn đã vô tình tạo một lỗ hổng về an toàn cho website của mình. Hãy cùng tìm hiểu vì sao lại như vậy.

# Luận bàn

# 1. Tìm hiểu về Sql Injection

Quay lại ví dụ bên trên, nội dung câu lệnh này nhắm lấy ra sản phẩm có tên là `Meo con di lon ton`. Vậy có gì sai nhỉ?

Để nói rõ hơn, thì câu lệnh này là một câu lệnh được support bởi 1 thư viện ORM mặc định trong rails tên là ActiveRecord. Nó sẽ được phiên dịch thành mã sql như sau:

```sql
  SELECT  "products".* FROM "products" WHERE (product_name = 'Meo con di lon ton')
```

Đây vẫn là một câu lệnh quen thuộc, và nhìn qua thì không thấy gì sai trái cả.

Flow hoạt động của website của tôi bình yên như vậy mà ta.

1. Người dùng submit lên server product_name.

2. Code xử lý ở server sẽ lấy product_name người dùng truyền lên và thực hiện truy vấn như trên.

3. Trả về kết quả cho người dùng.

Vậy có gì mà không ổn?

Với những người dùng thông thường thì. Đúng, mã nguồn của chúng ta hoàn toàn ổn. Nhưng nếu bạn là một ông chủ giàu có của một website nổi tiếng, và có nhiều kẻ ghét bạn vì bạn giàu hoặc nhìn mặt bạn thấy ghét và muốn tìm cách phá hoại website bạn thì sao?

**Vậy là thay vì gửi một product_name thông thường như "iphone x", "ghế tình yêu"...Thì họ lại gửi một product_name có dạng như  `chinh' or '' = '`**

Lúc này truy vấn của chúng ta sẽ trở thành:

```ruby
  Product.where("product_name = 'chinh' OR ''=''")
```

Chuyển sang dạng Sql:

```sql
  SELECT  "products".* FROM "products" WHERE (product_name = 'chinh' or '' = '')
```

Vì điều kiện trong where luôn trả về true bất kể product_name có bằng 'xxx' hay không (vì '' thì luôn luôn bằng '' :smile:). Nên câu truy vấn này sẽ trả về toàn bộ bảng products.

Và như vậy dữ liệu website của bạn đã bị lộ trước những kẻ không lấy gì làm tốt đẹp.

Trên đây chỉ là một ví dụ sơ sài, trong thực tế dữ liệu của bạn sẽ quan trọng hơn nhiều là cái products information như trên. Có thể là thông tin liên lạc, địa chỉ nhà, thông tin tài khoản ngân hàng...

# 2. Cách phòng tránh Sql Injection trong rails.

Có thể thấy khi để query dạng string như trên thì rất dễ bị khai thác, vì ActiveRecord sẽ không thể validate giá trị input mà người dùng nhập vào có hợp lệ hay không. Vậy cách tốt nhất để chống lại Sql injection chính là sử dụng query theo params thay vì sử dụng chuỗi như trên.

Thay vì viết:

```ruby
  Product.where("product_name  = 'Meo con di lon ton'")
```

Ta có thể viết dưới dạng params query như sau:

```ruby
  Product.where(product_name: 'Meo con di lon ton')
  # hoặc
  Product.where('product_name = ?', ['Meo con di lon ton'])
  # hoặc
  Product.where('product_name = :product_name', {:product_name => 'Meo con di lon ton'})
```

Với các cách thay thế, giá trị người dùng truyền vào sẽ được đảm bảo hợp lệ trước khi có dữ liệu trả về...


# Kết luận.

Đây là một bài sơ sài, ngắn gọn và khái quát cho người mới tìm hiểu về sql injection. Không phải bài viết chuyên sâu dành cho người có nhiều kinh nghiệm. Hãy để lại thảo luận nếu bạn có thắc mắc.
