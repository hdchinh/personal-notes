---
title: "Require Và Load Trong Ruby"
date: 2019-05-15
draft: false
tags: ["ruby"]
categories: ["ruby notes"]
mytag: "Ruby"
mytrend: "COOL"

---
## Đặt vấn đề

Khác với rails, một framework đã có hỗ trợ autoloading, một chương trình ruby đơn thuần không có cơ chế đó. Để sử dụng những mã nguồn phụ thuộc ta phải "gọi" chúng tại file hiện tại bằng method **require** hoặc **load**. Ví dụ:

```ruby
require 'animal'

class Cat < Animal
  def hello
    @cat = Animal.new
  end
end
```

Ở một vấn đề khác trong ruby, đó là ngôn ngữ này không hỗ trợ đa kế thừa, thay vào đó chúng có 1 cơ chế gọi là **mixin** để có thể sử dụng các phương thức trong nhiều **moudle** khác nhau. Ta sử dụng 2 method là **include** và **extend** để hiện thực hoá điều này.

## Luận bàn

## 1. So sánh require và require_relative

Trong tiêu đề bài viết không hề đề cập đến **require_relative** vậy sao giờ phải tìm hiểu về nó? Câu trả lời nằm ở cách mà phương thức **require** hoạt động.

Trở lại ví dụ trong mục đặt vấn đề, giả sử cả 2 file **cat.rb** và **animal.rb** nằm trong cùng một thư mục:

```
- app
  - cat.rb
  - animal.rb
```

Câu hỏi đặt ra là liệu đoạn mã trong phần đặt vấn đề có work với cấu trúc file như này hay không? Có hoặc không, đó là câu trả lời.

Khác với mường tượng ban đầu rằng phương thức require cũng sẽ bắt đầu tìm file từ thư mục gốc (thư mục chứa file gọi method) thì thực tế reuire tìm kiếm file bằng một cách khác.

Nó sẽ tìm đến biến global **$LOAD_PATH**, biến này là một đường dẫn, phương thức require sẽ tìm đến đường dẫn này và coi thư mục đó là gốc, nó sẽ tìm kiếm những file được requỉe bắt đầu từ thư mục đó. Trong lần đầu tiên nó tìm thấy thì ruby sẽ dừng chương trình ở đây và load file vừa tìm được lên. Nếu tìm hết các đường dẫn trong $LOAD_PATH và vẫn không thấy thì **LoadError** sẽ được gọi tới.

Trở về với câu hỏi bên trên, đoạn code của chúng ta work khi biến **$LOAD_PATH** được định nghĩa, và nó là đường dẫn tới thư mục đang làm việc (chính là folder app).

Trong tất cả các trường hợp còn lại, như khi biến này chưa được định nghĩa hay nó lại lại một đường dẫn đến một folder khác, thì đoạn mã khi đầu của chúng ta không thể chạy (vì require không tìm được file tương ứng theo yêu cầu).

Thứ bạn nhận được khi này chỉ là một thông báo lỗi **cannot load such file -- animal.rb (LoadError)**.

**Giải quyết vấn đề trên bằng cách nào?**

Ta sẽ có thể dùng 2 cách:

Cách 1: Điền thêm thư mục đang làm việc vào giá trị của biến **$LOAD_PATH**, khi này thì đoạn mã chúng ta sẽ sửa lại như sau:

```ruby
# nối thêm đường dẫn thư mục hiện tại vào giá trị hiện tại của biến $LOAD_PATH
$LOAD_PATH << File.join(File.dirname(__FILE__)
require 'animal'

class Cat < Animal
  def hello
    @cat = Animal.new
  end
end
```

Cách 2: Sử dụng **require_relative** thay thế cho require, sửa lại đoạn mã như sau:

```ruby
require_relative 'animal'

class Cat < Animal
  def hello
    @cat = Animal.new
  end
end
```

Cả hai phương pháp trên đều hoạt động bình thường.

> $: là một cách viết tắt cho $LOAD_PATH

## 2. So sánh require và load

Như trong mục 1 đã nói vể require, thực chất load có cách hoạt động và mục đích sử dụng rất giống với require. Cả 2 đều được dùng đê "gọi" những đoạn mã cần thiết vào file hiện tại đang làm việc, như việc bạn muốn import thêm một file js vào file html đang làm việc nào đó.

Tuy nhiên giữa chúng có một điểm khác nhau cơ bản, mà từ đó đã dẫn tới một lời khuyên về việc sử dụng chúng như sau:

```
Moreover, Kernel#require loads files once, but development is much more smooth
if code gets refreshed when it changes without restarting the server.
It would be nice to be able to use Kernel#load in development,
and Kernel#require in production.
```

**- trích dẫn guides.rubyonrails -**

:arrow_right: Điều rút ra ở đây là:

:one: require sẽ đọc và load file được gọi một lần duy nhất.

:two: load sẽ đọc và load file được gọi mỗi khi file đó được chạy.

Từ đó dẫn đến việc là load sẽ hữu dụng khi làm việc tại môi trường development hơn, nơi mà thay đổi diễn ra liên tục, còn require thích hợp khi triển khai lên production.

Note: Sau khi bạn chạy tới method require, nó sẽ đọc file bạn require và lưu tại bộ nhớ, những lần tiếp theo khi bạn chạy tới file đó, nó sẽ đọc nội dung từ bộ nhớ (mà nó đã lưu lại tại lần load đầu tiên), điều này giúp tăng performance vì không phải lood lại file lần nữa, nhưng đồng nghĩa với đó là những thay đổi sau đó tại file require sẽ không được load khi chạy.

## 3. So sánh include và extend

Không có nhiều liên hệ với hai mục đầu, 2 phương thức được đề cập trong mục 3 để giải quyết bài tóan mixin trong ruby, như đã có lần tôi trình bày khái quát [tại đây](https://hdchinh.com/post/2019-02-24-ruby-method-lookup/).

Có vẻ vì cao hứng chém gió title quá, mà tôi quên mất đã viết về hai phương thức này một lần, và hiện tại vẫn chưa có gì để bổ sung thêm, nếu cần hãy đọc lại bài viết tham khảo bên trên nhé.

## Kết luận

Tham khảo:

[1] [https://guides.rubyonrails.org/autoloading_and_reloading_constants.html](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html)
