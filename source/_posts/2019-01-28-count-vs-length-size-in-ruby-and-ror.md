---
title: "Length, Count và Size"
date: 2018-06-28
# draft: false
tags: ["ruby", "rails"]
categories: ["ruby notes"]
mytag: "Ruby"
mytrend: "COOL"

---

# Đặt vấn đề

Khoảng 1 năm trước, khi tôi bắt đầu học về Ruby on Rails, giống như nhiều developers khác, tôi chủ yếu tập trung vào cách để có thể xây dựng một ứng dụng ruby on rails chạy được mà không tập trung nhiều vào kiến thức Ruby nền tảng. Có lẽ đấy cũng là lựa chọn duy nhất vào thời điểm đó với một cậu sinh viên mới ra trường như tôi, khi mà có quá nhiều khái niệm, quá nhiều thứ phải học mà sếp của tôi cũng như sếp của bạn sẽ không trả lương cho chúng ta lên công ty để “học”.
Thời gian trôi qua, khi đã có nhiều kinh nghiệm hơn, tôi bắt đầu ngày càng hứng thú về những kiến thức nền tảng mà ngày xưa tôi chỉ từng đọc lướt qua. Trong đó có Count, Length và Size, những thứ tưởng như không có gì để nói hay tìm hiểu thêm, nhưng liệu chúng có thực sự đơn giản như vậy?

# Luận bàn

# 1.Tổng quan

Về cơ bản, đây là ba phương thức được Ruby cung cấp, và dĩ nhiên, nó hoàn toàn có thể sử dụng trong rails. Một cách thường xuyên nhất, bạn có thể thấy người ta sử dụng những phương thức này cho một mảng dữ liệu bất kì trong Ruby hay một mảng record trong Rails. Ý nghĩa của nó là trả về kích thước của mảng/hash. Ví dụ:

```ruby
array = Array.new(3,1)
#=> Tạo 1 mảng tên array có 3 phần tử đều có giá trị là 1.
array.size, array.length, array.count
#=> Kết quả trả về cùng là 3.
```

Nhưng mọi chuyện không dừng lại ở đấy, nếu chúng chỉ cùng có chung một chức năng thì không có lý do gì để chúng cùng tồn tại.

# 2.Trong ruby

Ngoài chức năng tính kích thước của một mảng hay một hash như đã được đề cập ở trên, Size có thể được sử dụng với cả đối tượng dạng chuỗi và dạng số nguyên.
Với chuỗi, Size sẽ trả về kết quả là số lượng ký tự của chuỗi. Còn với số nguyên, nó sẽ trả về số bite mà đối tượng đó nắm giữ trên bộ nhớ. Ví dụ:

```ruby
str_temp = "hduychinh"
str_temp.size
#=> Kết quả trả về độ dài chuỗi là 9.
int_temp = 12
int_temp.size
#=> Kết quả trả về là 8, ứng với 8 bytes mà int_temp lưu trữ trên bộ nhớ.
```

Length kém hơn size một chút, Length chỉ có thể sử dụng thêm cho các đối tượng dạng chuỗi để trả về số lượng ký tự trong chuỗi, mà không thể sử dụng trên số nguyên.

Cuối cùng là Count, nó không có chức năng gì bổ sung so với phần đã đề cập. Tuy nhiên, một điểm mạnh của Count đó là khi sử dụng với mảng/hash thì nó có thể nhận tham số chuyển vào. Ví dụ:

```ruby
c = [1, 2, 3, 3]
c.count 3
#=> Kết quả trả về là 2.
c.count { |i| i > 1 }
#=> Kết quả trả về là 3.
```

# 3.Trong Active Record

Khi sử dụng Count thực chất là bạn đang sử dụng lệnh sql `select count(*) from table_names` để truy vấn ra số lượng mà chúng ta đang cần tìm hiểu. Thứ hai, Count không được lưu trữ lại, điều đó có nghĩa mỗi lần bạn chạy hàm Count thì nó sẽ truy vấn vào cơ sở dữ liệu mà không hề quan tâm là bạn có gọi lệnh Count trước đó hay không. Thứ ba, Count là lệnh duy nhất trong ba lệnh trên có thể gọi trực tiếp thông qua một model class, ví dụ như: `Cat.count`.

Khi sử dụng Length, điều đầu tiên đó là load toàn bộ record mà bạn đang định đếm số lượng vào bộ nhớ rồi tính toán. Từ lần gọi thứ hai, nó sẽ lấy lại kết quả cũ chứ không load dữ liệu lên nữa. Đây thực sự là một điều tồi tệ nếu bạn có một cơ sở dữ liệu lớn, nó có thể load hàng triệu record vào bộ nhớ.

```ruby
Cat.all.length
#=> Cat Load (0.2ms)  SELECT "cats".* FROM "cats"
```

Khi sử dụng Size, điều đầu tiên của nó là tìm xem kết quả của truy vấn đã có trong bộ nhớ hay chưa, nếu có rồi thì nó sẽ lấy ra và sử dụng, còn nếu chưa có, nó sẽ sử dụng một câu truy vấn SQL vào cơ sở dữ liệu để đếm số lượng. Điều này thật sự tuyệt vời, như một sự kết hợp giữa length và count.

# Kết luận

Theo dữ liệu từ fast-ruby thì method length chạy gần tương đương với size và chạy nhanh hơn hẳn so với count. Điểm lợi của count là nó có thể được gọi từ 1 class Model, giúp cú pháp tường minh hơn, cũng như việc có thể truyền tham số vào hàm.
Ngược lại trong các trường hợp khác, việc sử dụng size là khả dĩ hơn cả, đặc biệt với dữ liệu lớn thì nên tránh sử dụng length, vì đó có thể mang lại 1 thảm hoạ cho chương trình khi quá nhiều dữ liệu bị nạp vào bộ nhớ 1 cách vô ích.
