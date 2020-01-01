---
title: "Từ Khoá Super Trong Ruby?"
date: 2019-06-16
draft: false
tags: ["RUBY"]
categories: ["RUBY"]

---

## Đặt vấn đề

Kế thừa là một 1 trong 4 yếu tố cốt lõi tạo nên đặc tính hướng đối tượng của một ngôn ngữ (như những gì chúng ta đã được dạy ở trường). Riêng điều đó thôi đã đủ để thể hiện tầm quan trọng của nó (có thật không nhỉ :grimacing:).

Trong ngôn ngữ ruby có một từ khoá thường xuyên xuất hiện khi cần kế thừa hay override lại phương thức lớp cha đó là **super**.

Qua bài viết chúng ta sẽ cùng tìm hiểu về nó.

## Luận bàn

## 1. Định nghĩa

```
It calls a method on the parent class with the same name as the method that calls super.
```

Ví dụ:

```ruby
class Dog < Pig
  def testing
    super
  end
end
```

=> Khi ta gọi phương thức **testing** với một instance của lớp Dog, ruby sẽ đi đến class cha/ông/cụ/kỵ... của **Dog** để tìm và chạy phương thức **testing** được implement ở lớp cha/ông/cụ/kỵ... đó.

## 2. So sánh super và super()

Với những bạn mới học, chúng ta đôi lúc sẽ nhầm lẫn là 2 cách gọi này thực chất là một, cũng bởi vì ruby cho phép sử dụng **()** như một optional, tức là có cũng được mà không có cũng được.

Nhưng thực ra không phải vậy, 2 cách sử dụng này sẽ dẫn đến các kết qủa khác nhau.

Cùng xét một ví dụ: Giả sử tôi có class Cat và một class con của Cat tên là YellowCat, mã nguồn như sau.

Sử dụng super

```ruby
class Cat
  def initialize
    puts "i'm meo"
  end
end

class YellowCat < Cat
  def initialize
    super
  end
end

YellowCat.new

# => i'm meo
```

Sử dụng super()

```ruby
class Cat
  def initialize
    puts "i'm meo"
  end
end

class YellowCat < Cat
  def initialize
    super
  end
end

YellowCat.new

# => i'm meo
```

**Kết quả là tương tự nhau, điều này giúp chúng ta ghi nhớ một ý, đó là khi không có tham số truyền vào method thì dùng **super** hay **super()** là tương đương nhau**

Ta xét một ví dụ khác:

Sử dụng super

```ruby
class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class YellowCat < Cat
  def initialize(name)
    super
  end
end

meo = YellowCat.new('mi mi')

puts "ten meo: #{meo.name}"
# => ten meo: mi mi
```

Sử dụng super()

```ruby
class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class YellowCat < Cat
  def initialize(name)
    super()
  end
end

meo = YellowCat.new('mi mi')

puts "ten meo: #{meo.name}"
# => ten meo: mi mi
```

Đến bây giờ chúng ta đã phát sinh một lỗi **wrong number of arguments (given 0, expected 1)**.
Điều này xảy ra là vì:

**Với từ khoá **super** bạn sẽ truyền TẤT CẢ tham số lên method đó ở lớp cha. Còn với **super()** bạn chỉ truyền lên lớp cha những tham số mà bạn bỏ vào trong **super()**.**

Như ta thấy trong ví dụ trên, ta không bỏ gì vào **super()** => khi lên lớp cha (lớp Cat) method initialize yêu cầu tham số name nhưng chúng ta không truyền gì lên và từ đó dẫn đến lỗi wrong number of arguments.

Để khắc phục chúng ta chỉ cần truyền tham số vào super() để lớp Cat nhân được tham số đó.

```ruby
class YellowCat < Cat
  def initialize(name)
    super(name)
  end
end
```

## 3. Sự hữu ích của super()

Tôi có một bài toán:

:one: Tôi có 1 lớp Cat với 2 instance variable là name và age.
:two: Lớp YellowCat là lớp con của Cat.
:three: Lớp YellowCat có thêm 1 instance variable là role.

Xây dựng lớp Cat có vẻ đơn giản, ta làm như sau:

```ruby
class Cat < Animal
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

# => hoàn thành yêu cầu
```

Tiếp theo đến lớp  YellowCat, xem chừng cũng không khó:

```ruby
class YellowCat < Cat
  attr_accessor :yellow_cat_name, :yellow_cat_age, :role

  def initialize(yellow_cat_name, yellow_cat_age, role)
    @yellow_cat_name = yellow_cat_name
    @yellow_cat_age = yellow_cat_age
    @role = role
  end
end

# => Cũng hoàn thành yêu cầu.
```

Cách này cũng hoàn thành được yêu cầu của bài toán, nhưng nó không ổn tí nào. Vì sao? Vì khi bạn tạo một instance thuộc lớp YellowCat nó sẽ có tổng cộng 5 instance variable bao gồm 3 instance variable khai báo trong lớp YellowCat, và 2 trong lớp Cat (bị thừa 2 instance variable).

Điều này đi ngược lại với các quy tắc lập trình quan trọng chúng ta cần tuần thủ như DRY.

Đến đây sức mạnh **super()** sẽ được thời cơ để thể hiện. Ta sẽ optimize lại mã nguồn của YellowCat như sau:

```ruby
class YellowCat < Cat
  # thêm một instance variable
  attr_accessor :role

  def initialize(name, age, role)
    super(name, age)
    @role = role
  end
end

meo2 = YellowCat.new('ni ni', 10, 'admin')
puts "ten meo la: #{meo2.name} \ntuoi meo la: #{meo2.age} \nrole cua meo la: #{meo2.role}"

# => ten meo la: ni ni
# => tuoi meo la: 10
# => role cua meo la: admin
```

Ở lớp con chúng ta có thêm 1 instance variable, chúng ta khai báo cho mình nó và duy nhất mỗi nó :arrow_right: không lãng phí vùng nhớ và tận dụng được mã nguồn cũ.

Trong phương thức khởi tạo đối tượng YellowCat chúng ta khởi tạo biến instance mới, còn 2 instance variable được kế thừa từ lớp cha thì ta truyền tham số vào **super()** để truyền lên lớp cha và mặc kệ lớp cha xử lý thế nào thì tuỳ.

## Tham khảo

[1][https://odetocode.com/blogs/scott/archive/2010/07/13/ruby-initialize-and-super.aspx](https://odetocode.com/blogs/scott/archive/2010/07/13/ruby-initialize-and-super.aspx)
