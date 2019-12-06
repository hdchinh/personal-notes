---
title: "Exception Trong Rails"
date: 2019-06-10
draft: false
tags: ["RAILS"]
categories: ["RAILS"]
---

# Đặt vấn đề

Tôi có một số tình huống diễn ra hàng ngày về con mèo của tôi. Nếu nó đói tôi cho nó ăn, nếu nó đi vs lung tung tôi sẽ dọn dẹp chúng.

Nhưng bỗng một ngày con mèo stupid của tôi bị "người ngoài hành tinh bắt cóc", wtf?. Đây là một tình huống không bình thường và tôi không có một `HÀNH ĐỘNG THỐNG NHẤT` nào để đối phó với 1 tình huống như vậy, tôi có thể khóc, có thể báo công an, nhưng chắc chắn không thể có một cách giải quyết triệt để. Trong lập trình ta gọi những tình huống mà logic luận lý sai lệch không còn đi theo logic bình thường như này là một exception.

Ví dụ như máy tính của bạn không được thiết kế để thực hiện phép chia cho số 0. Vậy khi bạn bắt nó thực hiện phép chia cho số 0, nó sẽ nghĩ "wtf is going on?" và đành quăng ra cho bạn một thông báo về việc bạn đã bắt nó làm một việc mà nó không được thiết kế để làm.

Trong bài viết này chúng ta sẽ tìm hiểu về exception trong ruby.

# Luận bàn

# 1. Tìm hiểu về Exception

Đầu tiên chúng ta phải ghi nhớ rằng khi một exception được gọi, chương trình của bạn sẽ ngừng và đoạn code phía sau không thể chạy được nữa.

1. Tôi đến trường đón con mèo.

2. Tôi đem con mèo đi bán vào quán tiểu hổ.

Nếu ở `bước 1`, thay vì đón thành công con mèo, tôi lại dính một exception "MeoMissing" vì lý do nó bị người ngoài hành tinh bắt cóc.

Khi này dĩ nhiên chương trình sẽ dừng lại, vì tôi làm gì còn con mèo để mà đem nó đi bán ở  `bước 2`.

Quay về với ví dụ đơn giản là chia cho số 0:

```ruby
10/0
# => ZeroDivisionError (divided by 0)
```

`ZeroDivisionError` là một exception được ruby tạo ra để trả về khi bạn cố chia một số cho số 0.

```
  if (chia đàng hoàng)
    thực hiện phép tính.
  else
    if (chia cho số 0)
      trả về exception ZeroDivisionError
    end
  end
```

Flow logic đơn giản về exception như trên.

# 2. Làm sao để lấy về đối tượng Exception

Như chúng ta đã biết, gần như mọi thứ trong ruby đều là object(Ngoại trừ method và block). Vậy nên Exception cũng là một đối tượng.

ZeroDivisionError ở trên là một Class, vậy khi bạn thực hiện một phép chia cho số 0, bạn đã rơi vào trường hợp mà ZeroDivisionError quản lý và nó sẽ trả về một đối tượng ZeroDivisionError.

Vậy tức là ở 2 lần chia cho số 0 khác nhau, nó sẽ trả về cho bạn 2 object exception khác nhau chỉ là cùng một class ZeroDivisionError.

Vậy cách nào để bắt được đối tượng này? Cú pháp để thực hiện việc này sẽ như sau:

```ruby
begin
  meo = 10
  meo/0
rescue ZeroDivisionError => e
  puts "Exception Class: #{ e.class.name }"
  puts "Exception Message: #{ e.message }"
end
```

`rescue` là từ khoá sẽ giúp bạn lấy được đối tượng exception trả về. Như ví dụ trên tôi lấy đối tượng exeption trả về (nếu exception đó là dạng ZeroDivisionError) và truyền nó vào biến `e`. Từ đây `e` chính là object exception nếu exception đó xảy ra.

Tôi có thể dùng e để xuất ra các thông tin mà tôi cần như class name hay message thông báo lỗi.

# 3. Xây dựng một class Exception

Một sự thật hiển nhiên là những thiết kế có sẵn không bao giờ có thể cover cho tất cả các trường hợp có thể xảy ra trong thực tiễn. Đôi lúc bạn muốn thêm một exception để cover cho trường hợp của riêng dự án của bạn thì sao?

Câu trả lời mà tôi mới tìm được khá thú vị và cũng rất quen thuộc. Đó là Exception cũng có thể được tạo ra như một class bình thường. Hãy để nó kế thừa lớp `StandardError` là được.

```ruby
class MeoException < StandardError; end

```

Vậy là ta đã có một class exception của riêng mình. Khi cần gọi đến exception này thì ta sẽ gọi sử dụng phương thức `raise` để gọi một đối tượng.

```ruby
raise MeoException.new(params_gi_do_ma_ban_muon)
```

Vậy trong class class `MeoException` ta sẽ thiết kế những gì? :smile: Tôi cũng chưa tìm hiểu.

# 4. Các lớp Exception có sẵn trong Ruby

![hoa](/images/ruby-exception.jpg)

Đây là sơ đồ về các lớp exception trong ruby, nếu ta rescue một exception X, X lại có dăm 3 exception con, thì chỉ cần chương trình của bạn phát sinh vấn đề và trả ra một exception con nào đó thì X được gọi.

# 5. Cách bắt Exception hợp lý

**Cách 1:**

```ruby
begin
  di_don_con_meo_truong()
rescue Exception => e
  # do something
end
```

Đây là một cách tệ vì khi rescue với Exception, lớp cha của tất cả các Exception khác thì nó cover quá nhiều trường hợp cũng trả ra exception, hãy nhớ lại ở trên chúng ta đã nói một khi Exception được trả về thì chương trình của bạn sẽ dừng lại. Vậy nên không sử dụng cách này.

**Cách 2:**

```ruby
begin
  di_don_con_meo_truong()
rescue StandardError => e
  # do something
end
```

Đây là cách làm tốt hơn, vì ta chỉ cover các lỗi standard, ít ra chương trình của bạn sẽ không thi thoảng bị shutdown mà không biết vì sao như cách đầu tiên.

**Cách 3:**

```ruby
begin
  di_don_con_meo_truong()
rescue MeoBiBatCoc, MeoBiDauChan => e
  # do something
end
```

Đây là cách tốt nhất, ta goi trực tiếp đến trường hợp ngoại lệ mà ta cần bắt lấy và xử lý.

# Kết luận

Nếu có phản hồi hãy để lại bình luận bên dưới bài viết.
