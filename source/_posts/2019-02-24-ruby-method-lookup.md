---
title: "Ruby Method Lookup"
date: 2019-02-24
draft: false
tags: ["ruby"]
categories: ["ruby notes"]
mytag: "#TIL"
---

# Đặt vấn đề

Cũng như nhiều ngôn ngữ khác, trong ruby, khi làm việc với một đối tượng thì có hai thứ ta phải quan tâm chính đó là thuộc tính của đối tượng và phương thức mà đối tượng có thể sử dụng (à mà gần như mọi thứ trong ruby đều là `object` nên đây là một kiến thức cơ bản nhưng cũng rất quan trọng cần phải nắm rõ). Việc ta có thể sử dụng phương thức của đối tượng thông qua dấu `.` không phải là gì mới mẻ, nhưng có một số điều đáng ghi nhớ về cách mà ruby tìm kiếm phương thức.

# Luận bàn

# 1. Method Lookup

Đã khi nào bạn tự hỏi, giả sử nếu bạn có một class A, và class này include thêm hai module vào nữa, nếu trong hai module đó cùng định nghĩa một phương thức, vậy khi instance của A gọi đến phương thức đó, điều gì sẽ xảy ra? Phương thức trong module nào được chạy?


Câu trả lời là thứ tự các phương thức được ruby tìm kiếm như sau:

1. Phương thức được định nghĩa trong `object's singleton class`.

2. Phương thức trong `module` được mixin trong `singleton class`(Theo thứ tự đảo ngược, vào sau sẽ tìm kiếm trước).

3. Phương thức được định nghĩa trong `class` của đối tượng ta đang xét.

4. Phương thức trong các `module` được `include` vào class ta đang xét (Cũng theo tứ tự đảo ngược).

5. Phương thức trong `Super class` của class ta đang xét.

Để làm rõ điều đã nói hãy xét ví dụ dưới đây:

```ruby
module One
  def hello
    "I'm one (include in class Test)"
  end
end

module Two
  def hello
    "I'm two (include in class Test)"
  end
end

module Three
  def hello
    "I'm three (extend)"
  end
end

module Four
  def hello
    "I'm four (extend)"
  end
end

class FatherOfTest
  def hello
   "I'm father of test class"
  end
end

class Test < FatherOfTest
  include One
  include Two

  def hello
    "It's my hello - Test class"
  end
end

m = Test.new

def m.hello
  "I'm object m"
end

m.extend(Three)
m.extend(Four)

m.hello
```

Tất nhiên đoạn mã trên sẽ có output là:

`"I'm object m"`

Theo thứ tự tìm kiếm đã liệt kê ở trên, khi ruby tìm thấy phương thức lần đầu nó sẽ dừng tìm kiếm và khi đi hết các thứ tự và vẫn không tìm được thì nó sẽ gọi đến một phương thức mặc đinh là `method_missing`.

Bỏ đoạn code:

```ruby
def m.hello
  "I'm object m"
end
```

Chạy lại ta nhận được kết quả:

`"I'm four (extend)"`

Làm tương tự rồi ta sẽ tìm ra thứ tự ưu tiên kết quả như sau:

``` ruby
# phương thức hello cho riêng instance m
"I'm object m"
# phương thức được extend riêng cho m
"I'm four (extend)"
"I'm three (extend)"
# phương thức trong chính class Test, class của m
"It's my hello - Test class"
# phương thức trong module được include vào Class Test
"I'm two (include in class Test)"
"I'm one (include in class Test)"
# phương thức trong lớp cha của Class Test
"I'm father of test class"
```

Nếu bạn đang còn một chút bối rối vì những từ khoá và cách sử dụng `extend` và `include` hãy đọc tiếp mục dưới.

# 2. Extend, Include trong Ruby

Trong ruby không có đa kế thừa, thay vào đó ruby sử dụng `mixin`.

Một class chỉ được kế thừa từ một class khác. Tuy nhiên nó được `mixin` nhiều `module` bằng hai phương thức là `include` và `extend`.

`include:` với việc bạn include moudle A vào trong class B, đồng nghĩa với việc instance của class B có thể sử dụng tất cả các `instance method` trong moudle A. Vậy còn `module method` trong A thì sao? Câu trả lời là những `module method` trong A thì A sử dụng thôi.

`extend:` đúng với ngữ nghĩa của nó, `mở rộng`, `extend` có thể dùng để mở rộng một class hoặc cũng có thể dùng để mở rộng một instance.  Trong ví dụ trên mục 1, tôi `extend` object `m`, từ đó giúp m được mở rộng thêm các phương thức ứng với tất cả các `instance method` trong module nó extend (đây là "mở rộng" cho một đối tượng). Nếu tôi muốn mở rộng cho một class, tôi sẽ extend moudle trong class đó, và sau đó tất cả các `instance method` trong module sẽ trở thành như các `class method` cho class (đây là sự "mở rộng" cho một lớp). Vậy còn `module method` trong moudle thì sao?Câu trả lời vẫn như trên, những phương thức module thì để module đó sử dụng.

# Kết luận

Mixin là một chức năng mạnh mẽ trong ruby, nó giúp ta mở rộng class/object bằng các method mới. Tuy nhiên, hãy cẩn thận để đảm bảo bạn gọi đúng được method mà bạn cần.
