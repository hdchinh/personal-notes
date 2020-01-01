---
title: "Cập Nhật Dữ Liệu Với ActiveRecord"
date: 2019-05-08
draft: false
tags: ["RAILS"]
label: "[@til]"
---

## Đặt vấn đề

Ngoài phương thức thông dụng **update** để cập nhật dữ liệu. Rails nói chung hay Activerecord nói riêng còn cung cấp 1 số phương thức khác để thay đổi dữ liệu hiện có, hãy cùng tìm hiểu về chúng.

## Luận bàn

**Chuẩn bị:**

1. Tôi có một model **Cat** với 2 thuộc tính là **age** và **name**.

2. Trong model Cat tôi có 1 **validation** và 1 **callback** đơn giản.

**Để so sánh các phương thức chúng ta chú ý đến một số điểm sau:**

1. Phương thức nhận một field cần update hay nhiều field?

2. Phương thức update được cho một hay nhiều record?

3. Validate method có chạy hay không?

4. Callback có chạy hay không?

5. Trường update_at có được cập nhật hay không?

## 1. Phương thức update

**Instance method:**

Là phương thức được gọi thông qua một instance. Ta truyền vào field name cần cập nhật và giá trị mới sau cập nhật. Ta có thể truyền tham số dưới dạng hash.

Ví dụ:

```ruby
cat = Cat.first
cat.update(name: 'change name')
```

Nhiều tham số

```ruby
cat = Cat.first
cat.update(name: 'change name', age: 100)
```

Truyền dưới dạng hash

```ruby
cat = Cat.first
cat.update({:name => 'change name', :age => 1})
```

**Class method**

Là phương thức được gọi thông qua class model. Nhận vào 2 tham số, thứ nhất là id hoặc một mảng các id của record thuộc class cần cập nhật, thứ hai là một hash key-value các field name cần cập nhật và giá trị của chúng sau cập nhật.

Cập nhật 1 record

```ruby
Cat.update(1, {:name => 'change name'})
```

Cập nhật nhiều record

```ruby
Cat.update([1, 2, 3], {:name => 'change name'})
```

Note:

1. Trường updated_at đều được cập nhật lại khi dùng 2 phương thức trên.

2. Validate và callback đều được chạy.

3. Class method **update** thì có thể cập nhật nhiều record một lúc.

## 2. Phương thức update_attribute và update_attributes

Phương thức update_attribute nhận 2 tham số truyền vào, với tham số thứ nhất là field cần cập nhật và tham số thứ 2 là giá trị cập nhật (Khác với update, thì tham số truyền vào không thể để dưới dạng hash).

```ruby
cat = Cat.first
cat.update_attribute(:name, 'change name')
```

Phương thức update_attributes khác với update_attribute là nó nhận 1 tham số chứ không phải 2. Ta truyền tham số dưới hạng một hash cho phương này với giá trị key-value tương ứng field cần update và giá trị cần cập nhật.

```ruby
cat = Cat.first
cat.update_attributes({ :name => 'change name', :age => 20 })
# cách khác
cat.update_attributes({ name: 'meo tam the 2', age: 20 })
```

Note:

1. Trường updated_at có được cập nhật lại.

2. Callback vẫn chạy nhưng **không** chạy validate.

3. update_attribute dùng cho cập nhật 1 field còn update_attributes cần khi cập nhật nhiều field.

## 3. Phương update_column và update_columns

Phương thức update_column có cú pháp giống như update_attribute, còn phương thức update_columns thì có cú pháp tương tự như update_attributes.

```ruby
cat = Cat.first
cat.update_column(:name, 'change name')

# với update_columns
cat.update_columns(name: 'change name', age: 10)
# or
cat.update_columns(:name => 'change name', :age => 10)
```

Tuy nhiên ta có một số điểm khác biệt cơ bản cần lưu ý với update_attribute và update_attributes cần lưu ý.

Note: Với phương thức update_column và update_columns

1. Trường updated_at không được cập nhật.

2. Callback và validate đều **không** được chạy.

## Kết luận

Cách đây ít lâu tôi có làm 1 ứng dụng nhỏ, trong đó có một model chính gọi là X, trong model này tôi có viết một callback tên Y được thực hiện sau khi record được save (với method after_save). Trong callback Y tôi sử dụng method **update**.

Đáng buồn thay là đoạn code của tôi không hoạt động một cách bình thường, sau khi save record thì terminal bị crash với một vòng lặp bất tận, chợt nhận ra là khi sử dụng **update** thì callback được gọi lại, vậy là nó tạo ra một vòng lặp vĩnh viễn, save record(1) -> callback được gọi(2) -> trong callback có phương thức update(3) -> update được gọi(4) -> update lại gọi lại callback(2).
Để khắc phục thì cần chuyển **update** thành **update_column** hoặc **update_columns**.
