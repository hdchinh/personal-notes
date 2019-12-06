---
title: "Tổng Quan Nguyên Lý SOLID"
date: 2019-05-17
draft: false
tags: ["SOLID", "RUBY"]
categories: ["RUBY", "PROGRAMMING"]
---
## Đặt vấn đề

Cách đây một thời gian, tôi có làm một ứng dụng nhỏ với vỏn vẹn tổng cộng tầm 500 dòng code. Khi bắt đầu tôi đã mường tượng rằng đây chỉ là một chương trình đơn giản nên không cần phân chia gì cho tốn công sức màu mè. Vì vậy tôi chỉ code trên vài file nhất định.

Một thời gian sau, tôi cần mở rộng thêm 1 vài chức năng nữa, rất tệ là lúc này tôi đã gần như quên luôn các logic mình đã làm trong đống code cũ, cắn răng đọc lại từng dòng, từng dòng, và tốn thời gian gấp 3 gấp 4 lần để hệ thống lại cho dễ hiểu hơn. Một bài học không phải cay đắng lắm cho tôi, nó chỉ tôi hiểu rằng việc cấu trúc và cách tiếp cận khi lập trình quan trọng đến thế nào.

Phần lớn thời gian một ứng dụng trên tay dev là để maintain, vậy nên việc ngày hôm nay bạn làm nó ra sao ảnh hưởng rất lớn đến sau này. Đó là một phần lý do mà tôi phải tìm đường cách mạng qua SOLID và những mẫu design pattern, những thứ văn vở mà ngày xưa tôi rất ghét và thấy thừa thãi, nhưng giờ đây nó như một bầu trời chân lý sáng chói loé qua tim.

## Luận bàn

## 1. Định nghĩa và mục tiêu sử dụng

![hoa](/images/solid.png)

Trước tiên, hãy xem SOLID là viết tắt của những cụm từ gì.

:one: **S**ingle Responsibility Principle

:two: **O**pen/Closed Principle

:three: **L**iskov Substitution Principle

:four: **I**nterface Segregation Principle

:five: **D**ependency Inversion Principle

Hàn lâm là vậy nhưng để dễ nhớ thì tôi gọi chúng ngắn gọn là: **S**ingle, **O**pen, **L**iskov, **I**nterface và **D**ependency.

Về mục tiêu để cái nguyên lý này có mặt trên cõi đời, âu cũng là xuất phát từ nhu cầu làm ít hơn của con người, việc code không có hệ thống khiến các nhà phát triển tốn nhiều thời gian bảo trì và dễ phát sinh lỗi trong quá trình sử dụng.
Để giảm bớt gánh nặng này các nhà phát triển đã cô đọng lại một số khuôn khổ, cách thức lập trình mà dưới góc nhìn và kinh nghiệm của nhiều người, các khuôn khổ cách thức đó giúp cho việc bảo trì trở nên dễ dàng hơn, hệ thống ít phát sinh lỗi ngoài ý muốn hơn. Một trong số đó là hệ thống các nguyên tắc trong SOLID.

Giả sử tôi phải xử lý một bài toán tính promotion cho một ứng dụng thương mại điện tử. Đây sẽ là ví dụ ta dùng đến trong các phần phía dưới. Giả sử cấu trúc dự án hiện tại như sau:

```
- app
  - signin.rb
  - signup.rb
  - checkout.rb
```

Trong đó signin chứa mã nguồn thực hiện chức năng đăng nhập, signup chứa mã thực hiện chức năng đăng ký và checkout chứa mã thực hiện chức năng thanh toán.

## 2. **S**ingle Responsibility Principle

![hoa](/images/srp.jpg)

Nguyên lý này được phát biểu như sau:

> Every class should have a single responsibility, and that responsibility should be entirely encapsulated by the class.

Điều cần quan tâm ở đây là single responsibility có thể hiểu là gì? Nghĩa của responsibility là 'trách nhiệm', vậy 'trách nhiệm' trong code là gì?

Ta có thể hiểu nó đồng nghĩa với 'chức năng' hay không? Cứ giả sử như ta có thể hiểu nó là 'chức năng' vậy khi đó thì nguyên lý này có thể phát biểu lại thành như sau:

> Mỗi class nên chỉ mang một chức năng nhất định, và chức năng đó phải được đóng gói trong class này.

Bây giờ thì đã dễ hiểu hơn nhiều, quay trở về ví dụ, chúng ta cần viết một chức năng tính promotion. Ta có thể  viết chức năng này vào đâu?

Câu trả lời đơn giản nhất là chúng ta viết chức năng này luôn vào file checkout.rb, khi thực hiện chức năng thanh toán thì sử dụng luôn các method tính promotion trong đó. Mọi chuyện thật đơn giản phải không? Điều này có vi phạm nguyên tắc SRP không?

Nếu tôi nói là không vi phạm? Diễn giải của tôi như sau: Trách nhiệm của cái module/class Checkout là thanh toán những mặt hàng bạn đã bỏ vào cart, vậy promotion cũng chỉ một step trong quá trình thanh toán, nên nếu tôi viết code promotion trong module/class Checkout thì tôi vi phạm nguyên tắc SRP chỗ nào?  Checkout vẫn đang làm đúng và duy nhất một 'trách nhiệm' đó là giúp thanh toán đơn hàng và promotion chỉ là phần phụ trợ cho quá trình đó hay nói cách khác promotion chỉ là một bước trong nhiều bước của quá trình thanh toán.

Vậy tôi có sai khi nói vậy không? Bạn có thể chứng minh là tôi sai nguyên lý SRP được hay không?

1. Tôi nghe nhiều người nói đây là nguyên tắc dễ nhất trong SOLID, theo tôi nó chỉ là nguyên tắc mà định nghĩa dễ học thuộc nhất mà thôi.

2. Responsibility thì hãy hiểu nó là responsibility (hay hiểu nó là đúng ngữ nghĩa là trách nhiệm). Không đánh đồng responsibility thành 'chức năng' như trên.

3. Nội dung nguyên lý chỉ có tính tương đối, nó phụ thuộc hoàn toàn vào cái mà bạn xem là một responsibility.

Để đánh giá đâu, cái gì là một responsibility thì có lẽ điều kiện cần là phải có đủ kinh nghiệm. Trở lại ví dụ, tôi có thể coi promotion là một responsibility riêng rẽ với chức năng thanh toán. Khi đó tổ chức code của tôi như sau:

```
- app
  - signin.rb
  - signup.rb
  - checkout.rb
  - promotion.rb
```

Như này đã phải là cách tốt nhất? Câu trả lời là tuỳ ngữ điệu hoàn cảnh, giả sử nếu chức năng promotion có nhiều rule khác nhau thì việc bỏ tất cả function tính promotion vào 1 file promotion.rb có vẻ không phải là một cách hay. Khi đó ta tổ chức lại như sau:

```
- app
  - signin.rb
  - signup.rb
  - checkout.rb
  - promotion
    - promotion_type_a.rb
    - promotion_type_b.rb
    - promotion_type_c.rb
```

Cách tổ chức này đã là tốt nhất hay chưa? câu trả lời là chưa chắc, mọi thứ lại phụ thuộc vào ngữ cảnh.
Nguyên lý SRP có thể sai hay đúng trong một số trường hợp là rất mập mờ, tuỳ theo cái mà nhà phát triển định nghĩa cho responsibility mà họ xây dựng.

Note: Nhưng cuối cùng nguyên lý SRP cũng chỉ có một mục đích duy nhất để cấu trúc dự án dễ sửa đổi và bảo trì, vì vậy trong từng tình huống sẽ có những cách khác nhau để phân chia tổ chức mã nguồn, dựa vào chức năng, dựa vào yêu cầu khách hàng, dựa vào tiềm năng phát triển dự án...

## 3. **O**pen/Closed Principle

![hoa](/images/ocp.jpg)

Nguyên lý này được phát biểu như sau:

> One software entity (class/module) must be open for extension but closed for modification.

Hiểu đơn giản:

> Một class/module cần phải có thể mở rộng, nhưng không/không nên sửa đổi nó.

Vì sao nguyên lý này lại yêu cầu như vậy? việc tôi muốn mở rộng hay tôi sửa đổi một cái class thì có ảnh hưởng gì đâu mà căng nhỉ?

Đúng là như vậy, trong phần lớn quá trình phát triển những ứng dụng cá nhân đơn giản thì việc chúng ta có thêm, xoá, sửa hay mở rộng một class/module đa phần đều không mang lại hậu quả gì ngoài ý muốn.

Nhưng ngữ cảnh mà nguyên lý này hướng tới là những ứng dụng thực sự trong cuộc sống, ở đó những ứng dụng này sẽ lớn, rối rắm và có business không hề đơn giản. Một điểm nữa là dự án đó khi tới tay bạn đã có thể trải qua 5, 7 lần đổi team phát triển và những gì bạn thấy là thành quả của cả một quá trình phát triển tính năng và maintain trong đơn vị tính bằng năm.

Liệu bạn có nắm hết được flow hoạt động của từng đoạn mã, từng file từng class hay không? Nhất định là không rồi.

Đó chính là lý do mà nguyên lý OCP ra đời, khi hệ thống phức tạp và bạn không nắm được hết tất cả những gì sẽ xảy ra sau khi bạn thay đổi mã nguồn tại một class/module. Hãy đừng thay đổi, để tránh làm ảnh hưởng đến một phần logic tiềm tàng nào đó. Thay vào đó hãy mở rộng class/module đó, mở rộng để bổ sung tính năng bạn cần mà còn giúp không ảnh hưởng đến những phần code cũ không sai lệch về logic luận lý (Vì nó có thể vẫn đang sử dụng chức năng cũ, liệu bạn có cover được hết để sửa đổi tất cả các trường hợp có thể xảy ra hay không?).

> Vì vậy hãy ưu tiên mở rộng một class/module khi cần phát triển thêm hay thay đổi tính năng, hạn chế và hãy thật cẩn thận khi cần sửa đổi mã nguồn có sẵn (chính là sửa đổi class/module).

Mục tiêu của nguyên lý là vậy, rất dễ hiểu, hãy cùng thảo luận về một ví dụ trước khi sang phần tiếp theo:

Lại quay trở lại ví dụ về bài toán promotion, giả sử tôi lự chọn cấu trúc chương trình như sau:

```
- app
  - signin.rb
  - signup.rb
  - checkout.rb
  - promotion.rb
```

Như đã trình bày ở trên, cấu trúc như này về lý thuyết thì cũng chả ai bảo là tôi vi phạm nguyên tắc số 1 SRP được. Giả sử nội dung của file promotion.rb như sau:

```ruby
class Promotion
  def promotion_type_a
    # implement rule promotion type a
  end

  def promotion_type_b
    # implement rule promotion type b
  end
end
```

Vậy bây giờ khi tôi muốn thêm một rule tính promotion mới, thì tôi sẽ phải sửa đổi file promotion.rb này, về nguyên tắc nó đã vi phạm nguyên lý số 2 OCP (mở để mở rộng chứ không phải để sửa đổi).

Để khắc phục ta có thể cấu trúc lại mã nguồn như sau:

```
- app
  - signin.rb
  - signup.rb
  - checkout.rb
  - promotion
    - promotion.rb
    - promotion_type_a.rb
    - promotion_type_b.rb
    - promotion_type_c.rb
```

Và khi này, khi tôi cần thêm mới 1 rule promotion, tôi sẽ tạo một file mới trong thư mục promotion, với nội dung kế thừa từ class Promotion.

Ví dụ bổ sung thêm rule promotion_type_x.rb với nội dung:

```ruby
class PromotionTypeX < Promotion
  # do something
end
```

## 4. **L**iskov Substitution Principle

![hoa](/images/lsp.jpg)

Nguyên lý này được phát biểu như sau:

> If S is a subtype of T, then objects of type T may be replaced with objects of type S (i.e., objects of type S may substitute objects of type T) without altering any of the desirable properties of that program (correctness, task performed, etc.).

Hiểu đơn giản là:

> Bạn có class A là con của class B, thì instance của class A phải thay thế được cho instance của class B trong mã nguồn mà không gây ra sai xót nào (không lỗi và không sai ngữ nghĩa).

Một ví dụ đơn giản như sau:

```ruby
class Animal
  def animal_hello
    puts "Animal say hello"
  end
end

class Cat < Animal
  def cat_hello
    puts "Cat say hello"
  end
end
```

Đoạn mã trên là một đoạn mã hợp lệ với nguyên lý Liskov vì:

```ruby
temp = Animal.new
temp.animal_hello
# kết quả trả về là: "Animal say hello"

temp = Cat.new
temp.animal_hello
# kết quả trả về vẫn là: "Animal say hello"
```

Như bạn thấy, kết quả trả về không thay đổi khi ta dùng instance của class Cat thay cho instance class cha của nó là Animal, và vậy là nguyên lý Liskov được bảo toàn tính đúng đắn của nó.

Hãy thử một đoạn mã nguồn khác như sau:

```ruby
class Animal
  def animal_hello
    puts "Animal say hello"
  end
end

class Cat < Animal
  def animal_hello
    puts "Cat say hello"
  end
end
```

Đây là đoạn mã vi phạm nguyên tắc của Liskov, khi này ta có:

```ruby
temp = Animal.new
temp.animal_hello
# kết quả trả về là: "Animal say hello"

temp = Cat.new
temp.animal_hello
# kết quả trả về là: "Cat say hello"
```

Ta có thể thấy, instance của class Cat khi gọi tới method animal_hello đã không còn trả về kết quả tương tự như một instance Animal nữa rồi, vì lý do ở class Cat, class này đã override lại phương thức animal_hello, và từ đó dẫn tới vi phạm nguyên tắc Liskov.

## 5. **I**nterface Segregation Principle

![hoa](/images/isp.png)

Nguyên lý này được phát biểu như sau:

> No client should be forced to depend on methods it does not use.

Hiểu đơn giản là:

> Nếu bạn là một đối tượng nào đó trong mã nguồn, hãy đảm bảo là bạn phải/chỉ làm những công việc mà bạn phải/có thể làm. Không trao cho bạn những khả năng mà bạn không cần.

Thử một ví dụ đơn giản, bạn là một học sinh được giao nhiệm vụ trực nhật lớp, cô giáo bạn phải đảm bảo rằng bạn chỉ được trao chìa khoá mở cửa phòng học của bạn, chứ không trao cho bạn những chìa khoá khác (như chìa khoá các lớp học khác, phòng tin học, phòng giáo viên...), đấy là những công việc của những cá nhân khác.

Nếu bạn được trao những công việc của người khác, có thể bạn sẽ tạo ra những sai lầm không thể sửa đổi được. Vì vậy hãy làm đúng công việc của mình.

Hãy bắt đầu với một ví dụ:

Ta có một class Animal.

```ruby
class Animal
  include AnimalHelper
  # do something
end
```

Class Animal bên trên include module dưới đây.

```ruby
module AnimalHelper
  def animal_helper_a
    # do something
  end

  def animal_helper_b
    # do something
  end

  def animal_helper_c
    # do something
  end
end
```

Mọi chuyện ổn chứ? Rất ổn, 3 method hiện có trong module AnimalHelper là 3 method hỗ trợ cho class Animal.

Vậy bây giờ tôi có thêm một class nữa như sau:

```ruby
class YellowCat
  # do something
end
```

Class này cần một phương thức support tên là `yellow_cat_helper`, tôi sẽ viết thêm method này vào module AnimalHelper và include module AnimalHelper vào class YellowCat vậy là đúng và đủ yêu cầu. Khi này module AnimalHelper và class YellowCat sẽ trở thành như sau:

Class YellowCat

```ruby
class YellowCat
  include AnimalHelper
  # do something
end
```

Module AnimalHelper

```ruby
module AnimalHelper
  def animal_helper_a
    # do something
  end

  def animal_helper_b
    # do something
  end

  def animal_helper_c
    # do something
  end

  # add new method for YellowCat
  def yellow_cat_helper
    # do something
  end
end
```

Mọi chuyện giờ vẫn ổn chứ? Không, bây giờ thì không ổn nữa rồi nó đã vi phạm nguyên tắc SOLID thứ 4, chữ "I" mà chúng ta đang xét.

Vì sao?

Vì class Animal đâu có cần method `yellow_cat_helper`, còn class YellowCat đâu có cần 3 method `animal_helper_a`, `animal_helper_b`, `animal_helper_c` này đâu?

Vậy mà chúng vẫn có thể sử dụng những method mà chúng vốn không cần, vì lý do ta viết chung tất cả method vào một module và include module vào từng class.

Y như ví dụ bên trên: Bạn cần trực nhật lớp 1A thôi mà, cô giáo bạn đưa cho bạn trùm chìa khoá của cả trường làm gì? Cầm thì nặng, mà nhỡ đâu bạn ~~tắt mắt~~ nghịch dại thì hậu quả khôn lường.

Vậy để không vi phạm nguyên tắc này ta có thể sửa lại mã nguồn như sau:

Class Animal

```ruby
class Animal
  include AnimalHelper
  # do something
end
```

Module Animal

```ruby
module AnimalHelper
  def animal_helper_a
    # do something
  end

  def animal_helper_b
    # do something
  end

  def animal_helper_c
    # do something
  end
end
```

Class YellowCat

```ruby
class YellowCat
  include YellowCatHelper
  # do something
end
```

Và giờ ta tạo một module mới để YellowCat include

```ruby
module YellowCatHelper
  def yellow_cat_helper
    # do something
  end
end
```

Ok, vậy là look good rồi :smile: Lúc này class Animal chỉ được include những method mà nó cần và class YellowCat cũng vậy.

## 6. **D**ependency Inversion Principle

![hoa](/images/dip.jpg)

Nguyên lý này được phát biểu như sau:

> 1. High-level modules should not depend on low-level modules. Both should depend on abstractions.
> 2. Abstractions should not depend upon details. Details should depend upon abstractions.

Dịch sát nghĩa sẽ là:

> 1. Module cấp cao không nên phụ thuộc vào module cấp thấp hơn. Cả hai nên phụ thuộc vào abstractions.
> 2. Abstractions không nên phụ thuộc vào details. Details nên phụ thuộc vào abstractions

Quay trở lại ví dụ promotion ban đầu, giả sử ta viết mã nguồn như sau:

```ruby
# app/checkout.rb
class Checkout
  def get_bill(cart)
    PromotionTypeA.promotion_type_a(cart)
  end
end

# app/promotion/promotion_type_a.rb
class PromotionTypeA
  def self.promotion_type_a(cart)
    # do something
  end
end
```

Trong đoạn mã nguồn trên đây, method get_bill trong class Checkout phụ thuộc vào class PromotionTypeA. Rõ ràng là như vậy, câu hỏi là nếu ta có PromotionTypeB, PromotionTypeC... Thì phải làm sao?

Chúng ta sẽ phải viết 3 method get_bill ứng với PromotionTypeA, PromotionTypeB và PromotionTypeC hay sao?

Đó cũng là một cách, nhưng đó là cách đã vi phạm nguyên lý DIP, khi mà các module phụ thuộc lẫn nhau.

Để giải quyết vấn đề này ta có thể viết lại mã nguồn như sau:

```ruby
# app/checkout.rb
class Checkout
  def get_bill(cart, PromotionType)
    PromotionType.get_promotion(cart)
  end
end

# app/promotion/promotion_type_a.rb
class PromotionTypeA
  def self.get_promotion(cart)
    # do something
  end
end

# get_bill với PromotionTypeA
Checkout.new.get_bill(cart, PromotionTypeA)

# để viết thêm PromotionTypeB, ta viết thêm một class PromotionTypeB và truyền PromotionTypeB vào get_bill method.

# app/promotion/promotion_type_a.rb
class PromotionTypeB
  def self.get_promotion(cart)
    # do something
  end
end

Checkout.new.get_bill(cart, PromotionTypeB)
```

## Kết luận

Trên đây là 1 cái nhìn tổng quan về hệ thống nguyên lý SOLID nổi tiếng, việc áp dụng nguyên lý này sẽ không chắc giúp mã nguồn bạn thành công, nhưng nó sẽ giảm thiểu rủi ro hơn là khi code bất chấp, lý thuyết chỉ là một phần nhỏ, nắm lý thuyết giúp chúng ta có cái nhìn tổng quát, trích rút lại thì thứ làm cho nguyên lý này có giá trị nằm ở kinh nghiệm sử dụng của nhà phát triển, không phải luôn luôn tuân thủ mọi quy tắc đã là tốt trong mọi trường hợp.

Nguồn tham khảo:

[1] [https://en.wikipedia.org/wiki/SOLID](https://en.wikipedia.org/wiki/SOLID)
