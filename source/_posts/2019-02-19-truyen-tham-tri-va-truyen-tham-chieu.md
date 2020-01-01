---
title: "Pass Reference Vs Pass Value, Ruby!"
date: 2019-02-19
draft: false
tags: ["RUBY"]
---

## 1. Định nghĩa

1. Không có một định nghĩa chung nào về **pass by value** và **pass by reference**, tuỳ thuộc vào từng ngôn ngữ, chúng lại có cách xử lý và những định nghĩa khác nhau về cách xử lý biến và vùng nhớ.

2. **Pass value**: Hiểu một cách đơn giản nhất, đó là khi biến bạn truyền vào một method nào đó, dù trong đó logic là gì và nó hà hiếp cái biến bạn bỏ vào ra làm sao, thì khi ra ngoài hàm đó, biến bạn đã truyền ở trên vẫn còn nguyên seal, nguyên kiện, không hề si nhê (không hề thay đổi về giá trị).

3. **Pass reference**: ngược lại với sự tử tế trong **Pass value**, khi bạn quyết định truyền tham số dưới dạng một reference, đồng nghĩa với việc bạn chấp nhận rằng cái biến bé bỏng, yếu ớt xinh xinh của bạn sẽ tha hồ bị logic trong hàm hành hạ, và khi ra khỏi hàng nó vẫn mang đầy đủ thương tích đã bị gây ra trong hàm (giá trị biến truyền vào sẽ bị thay đổi theo logic trong hàm).

Note: khi còn đi học, tôi đã có một sự nhầm lẫn về value và reference trong C, khi đó tôi đã nghĩ truyền tên biến bình thường thôi là **Pass value**, còn truyền con trỏ là **Pass reference**. Nhưng thực ra đó là không đúng:

>The C language is pass-by-value without exception. Passing a pointer as a parameter does not mean pass-by-reference.

## 2. Pass value và reference trong ruby

| Qua thời gian tìm hiểu thì tôi nhận thấy rằng trong ruby không hề có khái niệm rõ ràng về reference hay value, nên mọi kết luận ở đây chỉ là mang tính quy chiếu dựa vào những ý chúng ta đã nói trong mục 1.

Xem ví dụ sau đây:

```ruby
def xinchao(a)
  a = "Nguyen Van A"
end

temp = "Nguyen Van B"

puts "Kq: Xin Chao #{xinchao(temp)}"

#=> "Kq: Xin Chao Nguyen Van A"
```

Từ ví dụ trên ta có thể rút ra kết luận là ruby **Pass reference**? Vì như bạn đã thấy kết quả là "Nguyen Van A", giá trị mà chúng ta gán trong hàm **xinchao**.

Câu trả lời là không, đây là một ví dụ cạm bẫy nếu ta không cẩn thận, khác với một số ngôn ngữ khác bắt buộc phải sử dụng **return** để trả về kết quả trong function, ruby cho phép ta sử dụng giá trị cuối cùng bạn viết ra trong function đó. Tức kết quả trả về trên đơn giản là kết quả thực hiện của function xinchao, chứ còn việc biến temp có thay đổi giá trị hay không thì chúng ta phải thay thế lại một chút như dưới đây để kiểm chứng:

```ruby
def xinchao(a)
  a = "Nguyen Van A"
end

temp = "Nguyen Van B"

xinchao(temp)

puts "Kq: Xin Chao #{temp}"

#=> "Kq: Xin Chao Nguyen Van B"
```

Oh, vậy ruby là **Pass by value**? Đúng, như đã từng đề cập, ruby không có 1 định nghĩa thuần tuý nào về hai khái niệm mà chúng ta đang thảo luận, nên dựa trên những ý chính mà chúng ta đã thống nhất trong mục 1, ta có thể gọi Ruby là 1 một ngôn ngữ **Pass by value**.

Vậy có trường hợp ngoại lệ nào không? Như C++ có cả **Pass by value** và **Pass by reference** đó thôi? Theo tôi đọc được thì là không @@.
