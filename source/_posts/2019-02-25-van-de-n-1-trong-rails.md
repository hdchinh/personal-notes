---
title: "Vấn Đề N + 1 Và Hướng Xử Lý"
date: 2019-02-25
draft: false
tags: ["RAILS"]
---

## N+1 query

Xét một ví dụ:

Tôi có một ứng dụng đơn giản, với hai bảng csdl, bảng thứ nhất là bảng users, bảng thứ hai là bảng articles, một user có thể có nhiều articles nhưng một article chỉ thuộc về user. Hãy xem đoạn mã dưới đây:

```ruby
User.all.each do |user|
  user.articles
end
```
Đoạn code trên sẽ duyệt qua tất cả user có trong csdl rồi lấy tất cả các articles ứng với từng user. Rất tường minh và dễ hiểu.

Tối có 5 user mẫu trong csdl nên các câu lệnh sql sinh ra sau đoạn code trên như sau:

```ruby
# câu lệnh lấy hết users lên
SELECT "users".* FROM "users"
# ứng với mỗi user query lấy tất cả articles lên
SELECT  "articles".* FROM "articles" WHERE "articles"."user_id" = ? LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
SELECT  "articles".* FROM "articles" WHERE "articles"."user_id" = ? LIMIT ?  [["user_id", 2], ["LIMIT", 11]]
SELECT  "articles".* FROM "articles" WHERE "articles"."user_id" = ? LIMIT ?  [["user_id", 3], ["LIMIT", 11]]
SELECT  "articles".* FROM "articles" WHERE "articles"."user_id" = ? LIMIT ?  [["user_id", 4], ["LIMIT", 11]]
SELECT  "articles".* FROM "articles" WHERE "articles"."user_id" = ? LIMIT ?  [["user_id", 5], ["LIMIT", 11]]
```

Đây chính là ví dụ điển hình về **N+1**, **N**ở đây là 5 (số lượng user có trong csdl) và **1** chính là câu lệnh sql đầu tiên dùng để lấy tất cả user lên.

Nhìn như vô hại, mà thực ra ở ví dụ này cũng vô hại thật vì chỉ có 5 record user, nên thời gian load cũng không thấm tháp gì, tuy nhiên trong thực tế thì dữ liệu có thể rất lớn, lên đến hàng triệu record và nếu load dữ liệu như này thì đây là một vấn đề lớn cho hiệu năng của trang web. Hãy đọc tiếp mục 2 để tìm về giải pháp cho tình huống này.

## 2. Giải pháp

Vấn đề đã có, giờ chúng ta cần tìm một giải pháp làm sao để kết quả trả về không đổi, nhưng lượng truy vấn sql trong csdl phải nhỏ hơn.

Các phương án:

1. Sử dụng **select in()**.

2. Sử dụng **joins**. Để đọc kỹ hơn về joins, thì nên xem ở [đây](https://www.w3schools.com/sql/sql_join.asp)

Sử dụng select in() sẽ tiết kiệm truy vấn đi rất nhiều, nếu ví dụ bên trên ta sử dụng select in() thì các sql query cần thiết sẽ là như sau:

```ruby
# lấy tất cả query
SELECT "users".* FROM "users"
# lấy articles ứng với từng user
SELECT  "articles".* FROM "articles" WHERE "articles"."user_id" IN (1, 2, 3, 4, 5)
```

Tuyệt vời, từ 6(N + 1) truy vấn giờ đã trở thành còn 2.

Với cách thứ 2 là sử dụng **joins**:

joins hiểu đơn giản là ghép hai bảng lại với nhau (lấy một số field cần thiết ở bảng này, gộp với vài field cần thiết ở bảng kia khi mà record ở hai bên thoả mãn một điều kiện nào đó), rồi từ đó thành một bảng tạm dùng trong quá trình bạn sử dụng.

Quay trở về ví dụ ban đầu, câu truy vấn bây giờ sẽ trở thành:

```ruby
SELECT User.name, Article.title
      FROM User
      INNER JOIN Article ON User.id = Article.user_id
```

Lấy vài field cần thiết(name của user và title của Article).
Bằng cách thoả mãn điều kiện nào đó(id của user bằng với user_id của article).

Vậy từ N+1 query ban đầu, đã trở thành một query duy nhất.

Đến lúc này đã có thể kết luận là joins tốt hơn select in() được chưa? Chưa, câu trả lời sẽ là như vậy. Sang mục 3 chúng ta sẽ tìm hiểu về cách xử lý N+1 thông qua ActiveRecord

## 3. Xử lý N+1 query trong ActiveRecord

Trong ActiveRecord cung cấp 3 phương thức để loại bỏ N+1,

1. Sử dụng **preload**

```ruby
User.preload(:articles)
# sql sinh ra
User Load (0.2ms)  SELECT  "users".* FROM "users" LIMIT ?  [["LIMIT", 11]]
Article Load (0.4ms)  SELECT "articles".* FROM "articles" WHERE "articles"."user_id" IN (?, ?, ?)  [["user_id", 1], ["user_id", 2], ["user_id", 3]]
```
Preload sẽ luôn sử dụng **select in()**

2. Sử dụng **Eagerload**

```ruby
User.eager_load(:articles)
# sql sinh ra
SELECT  DISTINCT "users"."id" FROM "users" LEFT OUTER JOIN "articles" ON "articles"."user_id" = "users"."id" LIMIT ?  [["LIMIT", 11]]

SELECT "users"."id" AS t0_r0, "users"."name" AS t0_r1, "users"."created_at" AS t0_r2,
"users"."updated_at" AS t0_r3, "articles"."id" AS t1_r0, "articles"."name" AS t1_r1,
"articles"."user_id" AS t1_r2, "articles"."created_at" AS t1_r3, "articles"."updated_at" AS t1_r4
FROM "users" LEFT OUTER JOIN "articles" ON "articles"."user_id" = "users"."id"
WHERE "users"."id" IN (?, ?, ?)  [["id", 1], ["id", 2], ["id", 3]]
```

eager_load luôn sử dụng **joins**

3. Sử dụng **Inludes**

```ruby
# cách 1
User.includes(:articles)
# sql sinh ra
SELECT  "users".* FROM "users" LIMIT ?  [["LIMIT", 11]]
SELECT "articles".* FROM "articles" WHERE "articles"."user_id" IN (?, ?, ?)  [["user_id", 1], ["user_id", 2], ["user_id", 3]]
#=> giống preload

# cách 2
User.includes(:articles).references(:articles)
# sql sinh ra
SELECT  DISTINCT "users"."id" FROM "users" LEFT OUTER JOIN "articles"
ON "articles"."user_id" = "users"."id" LIMIT ?  [["LIMIT", 11]]
SELECT "users"."id" AS t0_r0, "users"."name" AS t0_r1, "users"."created_at" AS t0_r2,
"users"."updated_at" AS t0_r3, "articles"."id" AS t1_r0, "articles"."name" AS t1_r1,
"articles"."user_id" AS t1_r2, "articles"."created_at" AS t1_r3, "articles"."updated_at" AS t1_r4
FROM "users" LEFT OUTER JOIN "articles" ON "articles"."user_id" = "users"."id"
WHERE "users"."id" IN (?, ?, ?)  [["id", 1], ["id", 2], ["id", 3]]
#=> giống eager_load
```
Vậy mặc định thì **includes** sử dụng select in(), nhưng cũng có thể chuyển qua sử dụng joins nếu thêm method references phía sau.
