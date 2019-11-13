---
title: "Symbol Và String Trong Ruby"
date: 2019-06-09
draft: false
tags: ["ruby"]
categories: ["ruby notes"]
mytag: "Ruby"
mytrend: "COOL"
---

# Đặt vấn đề

Symbol là khái niệm rất quen tai và quen tay với lập trình viên ruby, ắt hẳn ai cũng đã từng nghe không ít thì nhiều, bản thân symbol cũng xuất hiện rất thường xuyên trong rails framework.

Khi tôi là thực tập sinh, tôi nhận được nhiều lời khuyên về việc nên sử dụng symbol nhưng chưa từng được nghe 1 lý giải đủ rõ ràng về việc vì sao nên sử dụng nó, mà có lẽ tôi cũng không thích nó, sự xuất hiện của symbol làm cú pháp trong rails không thống nhất khi có thể viết nhiều kiểu để biểu hiện cùng một ý nghĩa. Tôi không thích việc không đồng bộ đó chút nào.

Có một lý giải đơn giản và dễ nhớ để phân biệt giữa 2 đối tượng này đó là: Symbol mà giá trị giống nhau thì có cùng object_id, còn String thì dù giá trị giống nhau, mỗi chuỗi vẫn sẽ có một object_id khác nhau.
Liệu lý giải này đã đủ? Hãy cùng tìm hiểu.

# Luận bàn

# 1. Khai báo và tư tưởng

Để khai báo một symbol bạn thêm dấu `:` đằng trước.

```ruby
:meo

:"meo"
```

Đơn giản như trên, ta đã khai báo bằng 2 cách khác nhau. Nhưng thực tế ruby hiểu là chúng cùng là 1 symbol.

Điểm cần phải nói rõ trước khi đi xuống các phần sau đó là:

1. Symbol thực chất cũng là một String.

2. Symbol là một [immutable](https://hdchinh.com/programing/2019/04/08/immutable-va-mutable-trong-ruby.html).

# 2. Mutable và Immutable

Tôi đã từng trình bày một bài viết về chủ đề này. Các bạn có thể tham khảo tại [đây](https://hdchinh.com/programing/2019/04/08/immutable-va-mutable-trong-ruby.html).

Nhưng nói một cách vắn tắt thì biến X là một immutable khi mà vùng nhớ lưu giá trị của X không thể được thay đổi giá trị.

Như trình bày ở mục 1, symbol là immutable (khác với string thì là mutable).

Chúng ta có thể kết luận rằng, symbol thực chất là một string có tính chất bất biến giá trị (immutable).

Câu hỏi đặt ra là: Tại sao tôi lại cần những biến không thể thay đổi giá trị?

1. Trong quá trình lập trình, chúng ta cần một số biến không thể bị thay đổi giá trị trong quá trình sử dụng, để đảm bảo tính đúng đắn của chương trình. (Tôi không có ví dụ cụ thể nào).

2. Vì là mutable, nên mỗi khi một string được gọi, bất kể là các chuỗi có giống nhau hay không, ruby luôn tạo ra một vùng nhớ mới cho chúng.

```ruby
"Chinh".object_id
#  => 70159285001700
"Chinh".object_id
# => 70159284996100
"Chinh".object_id
# => 70159289079920
```

Ba chuỗi cùng một nội dung, nhưng khi được gọi thì lại có 3 object_id khác nhau, chứng tỏ rằng dù cùng giá trị nhưng ruby coi chúng là 3 đối tượng khác nhau và lưu trữ mỗi vùng nhớ riêng cho từng chuỗi.

**Vấn đề phát sinh từ đây khi mà  vùng nhớ bị lãng phí.**

Hãy cùng thử với symbol.

```ruby
:"Chinh".object_id
# => 1271588
:"Chinh".object_id
# => 1271588
:"Chinh".object_id
# => 1271588
```

Thật tuyệt, vậy là bằng một cách nào đó, khi sử dụng symbol, ruby biết được symbol này đã tồn tại hay chưa, nếu tồn tại rồi thì khi được gọi chúng sẽ dùng lại đối tượng đã có chứ không tạo thêm vùng nhớ mới.

# 3. Symbol và String được lưu trữ như nào.

Một tiêu đề có vẻ buồn cười, vì cái đối tượng trong ruby tất nhiên được lưu ở bộ nhớ trong với phân vùng gọi là heap.

Hiển nhiên String không ngoại lệ.

Nếu String được lưu trữ một cách bình thường và không thể kiểm soát xem nó lưu những gì (vì nó là mutable). Nên khi tạo ra một đối tượng String mới, Ruby sẽ tìm một vùng nhớ trống và lưu nó tại đó và không quan tâm xem là có bao nhiêu String đang hoạt động trong chương trình có nội dung giống nhau.

Vậy Symbol thì sao? Như đã trình bày ở mục trên thì bằng cách nào đó mà ruby có thể biết được symbol đã tồn tại hay chưa, nếu tồn tại thì xài lại còn chưa thì mới tạo ra vùng nhớ mới. Vậy chúng làm vậy bằng cách nào?

Thực ra không hề có phép màu nào ở đây cả, muốn truy vết symbol như nói ở trên thì chúng buộc phải được lưu trữ và quản lý dưới 1 dạng cơ sở dữ liệu nào đó.

Sự thật là Symbol được lưu trữ thành một table (thôi cứ tạm gọi là vậy), trong suốt quá trình vận hành một chương trình. Cứ tưởng tượng như việc bạn có 1 bảng trong excel, và khi có một dữ liệu mới được yêu cầu, bạn sẽ tra trong bảng excel này trước coi có chưa, nếu có rồi thì lấy ra xài lại. Còn nếu không có? thì sẽ làm 2 việc:

1. Tạo dữ liệu đó.
2. Lưu lại trong bảng để lần sau tra cứu.

Để lấy giá trị trong table lưu symbol nói trên ta có thể dụng lệnh:

```ruby
puts Symbol.all_symbols
# hoặc lấy tổng số symbol đã được lưu trữ trong chương trình.
puts Symbol.all_symbols.size
```

# 4. Về tốc độ thực thi

Qua những gì để phân tích. Ta rút ra một kết luận là Symbol thì tiết kiệm vùng nhớ một cách đáng kể so với String (xem lại cơ chế lưu vào table bên trên).

Nhưng vậy ngoài ra thì chúng còn gì khác biệt nữa không? Về performance thì sao?

Câu trả lời là Symbol vẫn nổi trội hơn String ở tốc độ thực thi:

- Trong trường hợp tạo một đối tượng mới: Symbol có thể sử dụng lại, còn String thì luôn luôn tạo mới. Ủa vậy thì tạo mới String phải nhanh hơn chứ ta. Vì nó không cần quét lại bảng table symbols mà luôn luôn tạo đối tượng mới, trong khi đó thì Symbol phải quét lại trước rồi nếu không có mới tạo đối tượng.

Nhưng mọi thứ không đơn giản như vậy, Trong ruby có một module gọi tắt là GC có chức năng thu gòm "rác", rác ở đây là các string được khai báo nhưng không còn sử dụng, GC sẽ thu hồi vùng nhớ của chúng để lấy không gian cho các đối tượng khác. Đây là một công việc vất vả.

Flow đơn giản của nó sẽ là:  GC quét các đối tượng => Đánh dấu các đối tượng không được sử dụng => Khi chương trình trong thời gian rảnh rỗi thì GC sẽ thu gồm vùng nhớ của các đối tượng bị đánh dấu. Sẽ tốt không ít thời gian cho công đoạn này.

Vì vậy về mặt performance khi tạo đối tượng mới, Symbol vẫn giành chiến thắng.

- Trong trường hợp so sánh 2 đối tượng: Chiến thắng một lần nữa thuộc về Symbol.

Lý do thì lần này khá đơn giản: Khi cần so sánh 2 symbol, ruby sẽ vào symbols table và so sánh là xong. Trong khi người anh em String thì không thể và để so sánh 2 chuỗi, ruby sẽ phải so sánh từng ký tự trong chuỗi này với từng ký tự trong chuỗi kia. Đây lại là một công việc vất vả.

Và thế là ta đã hiểu performance, Symbol win ez.

Để thử nghiệm bạn có thể sử dụng thư viện benchmark để kiểm nghiệm kết luận.

# 5. Điểm yếu của Symbol

Nếu Symbol toàn năng, toàn thiện thì đã không có lý do gì nó không thay thế luôn String. Bản chất của điểm yếu của Symbol cũng chính là điểm mạnh của nó.

Đó chính là tính chất immutable.

Vì không phải khi nào cũng cần một đối tượng immutable, tôi có một input là tên người dùng nhập vào. Tôi muốn chắc chắn là sẽ lưu tên người dùng dưới dạng chữ hoa trong csdl. Vì vậy tôi chạy method `upcase!`.

Tuy nhiên, Symbol là immutable mà phương thức `upcase!` lại có mục tiêu thay đổi giá trị của đối tượng và thế là chương trình bắn ra một error về việc bạn đang cố thay đổi giá trị của symbol.

Trong trường hợp này rõ ràng sử dụng String là điều hiển nhiên.

# Kết luận

Nếu có nhận xét hoặc phản hồi hãy để lại phản hồi bên dưới nhé.
