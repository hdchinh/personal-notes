---
title: "Immutable Và Mutable Trong Ruby"
date: 2019-04-08
draft: false
tags: ["RUBY"]
---

## 1. Khái niệm mutable, immutable và ruby

Đi thẳng vào vấn đề, chúng ta cần đề cập đến ba vấn đề: **mutable**, **immutable** và cách ruby xử lý hai khái niệm đó. Trước hết nếu bạn đã quên, thì tôi xin được nhắc lại định nghĩa của chúng.

Xin trích dẫn [wiki](https://en.wikipedia.org/wiki/Immutable_object):

> In object-oriented and functional programming, an immutable object (unchangeable[1] object) is an object whose state cannot be modified after it is created.[2] This is in contrast to a mutable object (changeable object), which can be modified after it is created.

Translate:

> Trong lập trình hướng đối tượng và lập trình hàm, một đối tượng được coi immutable, là một đối tượng **không thể thay đổi** trạng thái sau khi nó được tạo lần đầu, ngược lại với một đối tượng được coi là mutable nó có thể **thay đổi** trạng thái sau khi được khởi tạo lần đầu.

Dùng từ quá khó hiểu, what the hell is "trạng thái"? Theo một cách hàn lâm và đầy đủ, trạng thái của một đối tượng ngoài đời thật được thiết lập bởi tất cả những gì tạo nên chúng.

Tương tự, các trạng thái của một đối tượng trong lập trình cũng được thiết lập bằng tất cả những gì tạo nên chúng. Ví dụ:

Với 1 biến integer cơ bản **x = 10** thì trạng thái của nó được tạo ra bởi tên biến và giá trị, ở đây tên biến là **x** và giá trị là **10**, đâu đó trong vùng nhớ (Ram) của bạn sẽ lưu trữ cái chữ **x** kèm số **10** này.

Đồng nghĩa với đó nếu tôi thay đổi được giá trị 10 của biến x thì x là một đối tượng mutable và ngược lại nó là một đối tượng immutable.

Tôi gán **x = 11** và thành công

Từ đó có thể đưa ra kết luận x là một mutable?

Câu trả lời là không, một số khái niệm rối rắm làm khó ta lúc đầu. Như đã biết, thứ mà CPU làm việc là địa chỉ vùng nhớ và chỉ địa chỉ vùng nhớ mà thôi. Những thứ khác nó không quan tâm.

Với câu lệnh gán **x = 10**. Nó được hệ điều hành phiên dịch thành "có một biến tên **x** được gán giá trị bằng **10**, Ram, mày hãy bố trí thêm hai slot để lưu trữ **x** và **10**". Vậy lúc đó:

**x**(tên biến) được lưu ở vị trí AAA
**10**(giá trị) được lưu ở vị trí BBB

Với lệnh gán tiếp theo **x = 11**:

**x** vẫn yên vị nằm ở vị trí AAA
**10** cũng vẫn yên trí nằm ở vị trí BBB
**11** giá trị mới gán cho biến x thì lúc này nằm ở vị trí CCC

Vậy khi chạy một lệnh gán mới thì biến x đã được gán bằng giá trị trên một vùng nhớ khác, còn vùng nhớ ban đầu **không thay đổi giá trị** nên ta có thể kết luận x là một immutable.

Chứng minh bằng ví dụ sau trong ruby, chú ý là ruby là một ngôn ngữ script, với trình thông dịch VM bên dưới để xử lý của nó được viết bằng C, nên ở lớp cơ sở của ruby ta không thể truy xuất vị trí vùng nhớ đến từng thanh ghi như trong C được (việc đó được làm ở lớp core YARV). Tuy nhiên, ta có thể kiếm tra được vị trí tượng trưng trên bộ nhớ của nó thông qua **object_id**.

```ruby
x = 10
x.object_id
#=> 21
x = 11
x.object_id
#=> 23
```

Note: Nếu bạn gán tiếp x = 12 và kiểm tra lại object_id, lúc này bạn sẽ thấy nó bằng 25. Giá trị 10, 11, 12 tương đương với object_id là 21, 23, 25. Liệu có một quy luật nào ở đây? Câu trả lời là có, nhưng vấn đề này sẽ được đề cập đến trong một bài viết tiếp theo.

Từ ví dụ trên bạn đã hiểu về immutable, vậy còn mutable? Đơn giản nhất là hãy hiểu ngược lại với immutable, nêu gán x = 11 và x có object_id không đổi thì x chính là mutable.

```
Tất cả các loại dữ liệu nguyên thuỷ trong ruby đều là immutable.
```

Integer, float, string, boolean chúng đều là immutable.

## 2. Liệu đây có phải là một kiến thức cần thiết?

Chắc chắn là có.

Thứ nhất: Nếu trong công việc bạn không bao giờ phải dùng đến nó, bạn có thể nói về nó như một kiến thức hàn lâm để thể hiện khả năng với sếp và yêu cầu tăng lương :worried:

Thứ hai: Xét ví dụ sau

```ruby
str = ""
["Hoang", "Duy", "Chinh"].each do |i|
  str += i
end
```

Tư tưởng của đoạn mã này là cộng tất cả các phần tử trong một mảng string và cho ra kết quả cuối cùng là một chuỗi tổng hợp tất cả các phần tử.
Có điều gì bất thường trong đoạn mã này không nhỉ? Câu trả lời là có. Như những gì chúng ta đã nói ở trên có hai điều cần lưu ý:

> 1. Các kiểu dữ liệu nguyên thuỷ trong ruby đều là immutable và hiển nhiên string không ngoại lệ.

> 2. Khi một object là immutable, thì việc bạn gán nó bằng một giá trị khác đồng nghĩa với việc vùng nhớ cũ sẽ không được dùng đến, mà nó sẽ ra một vùng nhớ mới rồi ghi kết quả mới lên đó, cứ lặp lại như vậy mãi mãi.

Từ hai điều trên ta rút ra được kết luận:

1. Trong lần gán đầu tiên str có giá trị là chuỗi rỗng và được khởi tạo tại ví trí A1
2. Trong lần lặp **each** đầu tiên, str có giá trị là "Hoang" và nó lưu ở vị trí A2
3. Trong lần lặp **each** thứ hai, str có giá trị mới là "HoangDuy" và nó lưu ở vị trí mới là A3
4. Trong lần lặp cuối cùng thì str có giá trị chúng ta mong đợi là "HoangDuyChinh" và nó lưu ở vị trí A4

Chứng minh:

```ruby
str = ""
puts "First location: #{str.object_id}"
["Hoang", "Duy", "Chinh"].each do |i|
  str += i
  puts "value: #{str} | location: #{str.object_id}"
end

puts "Final value: #{str} | location: #{str.object_id}"
```

Kết quả:
```
First location: 47434608564740
value: Hoang | location: 47434608564520
value: HoangDuy | location: 47434608564440
value: HoangDuyChinh | location: 47434608564360
Final value: HoangDuyChinh | location: 47434608564360
```

Và thứ chúng ta quan tâm từ đó về sau là vị trí A4 này. Vậy còn A1, A2, A3 cũng đang mang giá trị? Chúng đi đâu về đâu? Chính xác, nó trở thành một vùng nhớ rác và sẽ được GC dọn dẹp nhưng không phải ngay lập tức, vậy trong khoảng thời gian đó nó vẫn nắm giữ các vùng nhớ của chúng ta. Đó cũng là một trong các lý do việc bạn muốn chạy ruby on rails trên một chiếc máy tính sinh viên 2GB là vô cùng khó khăn. Ruby ăn Ram như uống nước lã vậy.

Ví dụ trên mảng ta có ba phần tử và ta có 3 giá trị rác trên bộ nhớ, hãy tưởng tượng bạn có một mảng một triệu phần tử :worried:

Giải pháp trong trường hợp này là gì? Đó là duyệt mảng như một **object reference** chứ không phải một biến giá trị:

```ruby
str = ""
["Hoang", "Duy", "Chinh"].each do |i|
  str << i
end
```

Như vậy str sẽ ở đúng một vùng nhớ và ta không có một đống biến rác không mong đợi.

Chứng minh:

```ruby
str = ""
puts "First location: #{str.object_id}"
["Hoang", "Duy", "Chinh"].each do |i|
  str << i
  puts "value: #{str} | location: #{str.object_id}"
end

puts "Final value: #{str} | location: #{str.object_id}"
```

Kết quả:

```
First location: 47196120971580
value: Hoang | location: 47196120971580
value: HoangDuy | location: 47196120971580
value: HoangDuyChinh | location: 47196120971580
Final value: HoangDuyChinh | location: 47196120971580
```

## 3. Tham khảo

[1] [https://en.wikipedia.org/wiki/Immutable_object](https://en.wikipedia.org/wiki/Immutable_object)
