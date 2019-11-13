---
title: "Session Vs Cookies Trong Rails"
date: 2019-04-17
draft: false
tags: ["rails", "secure"]
categories: ["rails notes"]
mytag: "Rails"
mytrend: "COOL"
---

# Đặt vấn đề
`session[:user_id] = @user.id`, dòng code này thật quen thuộc? khi làm chức năng đăng nhập trong những ngày nhập môn, hẳn ai cũng đã từng làm qua hoặc làm gần giống như vậy, ta được dạy rằng, `http` là 1 giao thức không có trạng thái nên request thứ `N + 1` sẽ chẳng thể biết được request thứ `N` đã làm gì, vậy nếu ở lần request thứ `N` chúng ta đã thực hiện hành vi đăng nhập, và `http` thì không có lưu vết lại điều đó, hệ quả là ở lần request tiếp theo, website hiểu như bạn chưa đăng nhập, rất đáng buồn.

Cũng theo những gì được dạy, `session/cookies` được tạo ra với mục đích làm cho http request có "trạng thái". Vì sao lại để từ trạng thái trong nháy kép, vì thực sự là `http` không bao giờ có trạng thái cả, mà `session/cookies` với khả năng lưu vết của mình có thể giúp website nắm được một số **thông tin** từ client đã request trước đó và làm chúng giống như `http` đã có trạng thái.

Quá mơ hồ? đúng vậy, khi được dạy điều này tôi cũng thấy thật mơ hồ, wth is trạng thái? phi trạng thái? lưu vết?... Hy vọng bài viết này sẽ giúp người đọc có 1 cái nhìn dễ hiểu hơn về 2 đối tượng này trong ruby on rails.
# Luận bàn

# 1. Flow hoạt động

Một cách ngắn gọn cookies sẽ được vận hành như sau:

**Step 1**: Lần đầu bạn request đến web ABC.com, nhẹ nhàng tựa mây bay, bạn không mang theo thông tin gì của ABC.com cả

**Step 2**: ABC.com nhận request của bạn, nó nhận ra bạn không mang theo cookies của website, nên nó trong response trả về nó set một hoặc một vài cookies mặc định cho bạn.

**Step 3**: Bạn nhận được response của ABC.com, rồi bạn tiếp tục request lên ABC.com lần thứ 2, lần này đi theo request của bạn là toàn bộ số cookies đã được khởi tạo ở bước 2.

**Step 4**: ABC.com lại nhận được request của bạn, và lần này nó đã thấy bạn mang cookies của ABC.com nên nó sẽ đọc nội dung trong cookies đó (nếu cần).

# 2. Một vài loại cookies quan trọng trong rails

1. `Normal cookies`: Một dạng cookie mà dữ liệu được lưu trữ dưới dạng text.

2. `Signed cookies`: Một dạng cookie mà dữ liệu lưu trữ sẽ được "ký" bởi 1 `digest`, và `digest` này được tạo ra bởi `secret_key_base` trong app của bạn, sau đó nó sẽ được chuyển sang dạng `base64` code. Điều này có nghĩa là nếu ai đó có được `signed cookies` của bạn, thì họ hoàn toàn có thể đọc được nội dung bên trong (decode base64 là có thể đọc được). Tuy nhiên nếu họ sửa lại nội dung của cookies đó và gửi lên server thì lúc này, cookies này trở thành 1 cookies không hợp lệ, vì sao? Vì như đã trình bày, nó được ký bởi 1 digest sinh ra qua `secret_key_base`, vậy nên cookies loại này nếu bị sửa đổi nội dung ở client thì khi kiểm tra tính toàn vẹn trên server thông qua digest sẽ không còn đúng nữa. Và nó trở thành 1 cookies không hợp lệ.

3. `Encrypted cookies`: Một dạng cookies mà dữ liệu được mã hóa qua một quá trình mã hóa với 1 khóa quan trọng là `secret_key_base`, một cách đơn giản nhất để hiểu là không có `secret_key_base` thì ta không thể nào **đọc** hay sửa đổi dữ liệu của cookies này được.

Ví dụ:

```ruby
cookies.signed[:signed] = "Duy Chinh"
cookies.encrypted[:encrypted] = "Duy Chinh"
cookies[:normal] = "Duy Chinh"

```
Tôi đã tạo 3 cookies ứng với 3 dạng cookies nêu ở trên, giá trị của chúng đều giống nhau (đều được gán bằng "Duy Chinh").

Hãy xem giá trị ở client nhận được:

```ruby
normal = "Duy+Chinh"
signed = "IkR1eSBDaGluaCI%3D--a3af2bfd61abcd20cc3b8ac714968d0aaf578fe5"
encrypted = "%2BVulShtBgFR2I18%3D--zQP8FmCAW4%2FZUwar--CQ%2FH6HFHSVlox5H8QC4CTg%3D%3D"
```

Nhận xét:

1. Kiểu cookies thông thường, dữ liệu lưu dạng text nên ở client ta dễ dàng đọc được nội dung cũng như sửa đổi dữ liệu của chúng.

2. Nhìn signed cookies và encrypted cookies đều không thân thiện với người dùng cuối, vì chúng gồm những ký tự không có ngữ nghĩa với end user.

3. Nếu decode `base64` ta thu được giá trị của signed cookies ở trên là: `"Duy Chinh"7횿f߷횭Ƕч7oƜ뇴i繯Ǟ䀀`, dù một số ký tự phía sau không thể hiểu được, tuy nhiên không quan trọng vì nội dung cookies vẫn được giải mã (đúng với tính chất, có thể đọc nhưng không thể sửa đổi).

4. Việc decode encrypted cookies là vô vọng khi không có `secret_key_base`.

**NOTE:**

Việc sử dụng loại cookies nào sẽ đúng trong những trường hợp cụ thể, với những dữ liệu vô hại và không hề quan trọng thì sử dụng cookies thông thường và lưu mọi thứ dưới dạng text là khả dĩ hơn cả. Bỏ qua các bước mã hóa giúp nó hoạt động với performance tốt hơn hẳn 2 dạng cookies còn lại.
Ngược lại, encrypted cookies là dạng cookies tốn công sức để xử lý nhất, vì vậy hãy chỉ sử dụng nó cho những thông tin thực sự quan trọng và không thể để lộ (những thông tin bớt quan trọng hơn và chỉ cần đảm bảo tính toàn vẹn của dữ liệu chứ không cần bảo mật thông tin thì hãy dùng signed cookies).

# 3. Giải mã cookies và tìm hiểu về session trong rails

Sau khá nhiều công sức tìm kiếm, tôi đã tìm ra cách để giải mã cookies trong rails 5.2, nội dung đơn giản như sau:

```ruby
require 'cgi'
require 'active_support'

def verify_and_decrypt_session_cookie(cookie, secret_key_base)
  cookie                  = CGI::unescape(cookie)
  salt                    = 'authenticated encrypted cookie'
  encrypted_cookie_cipher = 'aes-256-gcm'
  serializer              = ActiveSupport::MessageEncryptor::NullSerializer

  key_generator           = ActiveSupport::KeyGenerator.new(secret_key_base, iterations: 1000)
  key_len                 = ActiveSupport::MessageEncryptor.key_len(encrypted_cookie_cipher)
  secret                  = key_generator.generate_key(salt, key_len)
  encryptor               = ActiveSupport::MessageEncryptor.new(secret, cipher: encrypted_cookie_cipher, serializer: serializer)

  encryptor.decrypt_and_verify(cookie)
end

cookie         = "QkS0eMMxz8z0Kso%3D--4opNQwT5tGUsnn90--5fXye0VQJX%2BXMVkUmK69gw%3D%3D"
skb            = "2fc48081a207cbe98379b2ed33b5072125d6f80a55997494b021bde37cec4d9c8f17f90357d6ade926b02a3bc271ccecaf6894af1410d6ef8f6c9b3b0d871fba"
cookie_session = "ahp9AcIyl%2BhLvQW695lhNUCnI7bF2iNZY8e4bM%2B2Lrx%2FlnbVXkYF3nL493dMM7eslFJKAyBNJKZlY5ugZpUuznCxO%2BpNXudnOdQVuDyvVBLxA8gQ4t48Gs%2BqOS7e%2FlSjBedhFKAaoBRdVI06QL8%3D--enarz3Hu%2FZ2n1Ys%2B--YdTghGWd4ZFef9Lf7WM%2FMQ%3D%3D"
puts verify_and_decrypt_session_cookie(cookie_session, skb)

```

Nội dung được tham khảo từ nhiều nguồn (vì không một nguồn cụ thể nào copy và chạy luôn được :unamused:), nhưng chủ yếu được tìm hiểu [tại đây](https://api.rubyonrails.org/classes/ActiveSupport/MessageEncryptor.html), các bạn có thể vào trang này để tìm hiểu kỹ hơn.

**NOTE:** Một điểm hết sức cần chú ý đó là biến `skb` tôi sử dụng ở trên chính là `secret_key_base` của project mà tôi sử dụng để demo, vì đây chỉ là một project test nên tôi có thể viết dạng text vào file sau đó commit lên github như này, trong tất cả các trường hợp khác thì đây là một hành động vô cùng **tồi tệ**, việc bị lộ `secret_key_base` sẽ khiến ứng dụng của bạn trần trụi trước hacker. Vậy nên hãy thật cẩn thận!

Đoạn mã trên work tốt trên rails 5.2, chú ý là cách mã hóa ở các phiên bản rails khác nhau hoàn toàn có khả năng khác nhau, nên nếu đoạn mã này không thể chạy được với rails 4 chẳng hạn thì đó là điều hết sức bình thường.

Trở lại vấn đề chính, nếu bạn để ý thì trong lần đầu tiên request khi bạn chưa hề làm gì và code trên server của bạn cũng chưa hề set bất kỳ giá trị cookies nào thì trong response trả về vẫn sẽ có một cookies (mà tôi đã nói ở trên, trong lần đầu request server sẽ khởi tạo và gửi về cho bạn một hoặc một vài cookies).

Trong trường hợp này là một, cookies đó có thể có tên dạng `_app_name_session`. Nội dung của cookies này cũng được mã hóa, thử decode bằng `base64` không được ta có thể hiểu đây là 1 cookies đã được encrypted.

Giá trị của cookies này trong trường hợp tôi test là:

```
"aW2fSskgCyZ20Fi6E68xRGl0%2FR%2FzeFWoWU5YdhgkVhB%2FMtWSsX0rf3JuRgsfPPgQXjYYNygaRSxRjXAmOcsjohN28JQJnjej0Grfpwx52cZ5qjIRdMfOS9aXdTmedpuJ7T99aObbv75D3dsPtdQ%3D--FW10HzOu9FIoKK%2B8--9sMKANggTvi%2BlBjFwpIHEg%3D%3D"
```

Sử dụng đoạn mã ta đã viết ở trên, ta giải mã ra được giá trị của cookies này là:

```ruby
{
  "session_id":"52cc440e209ad03d306e550c2ca2dd78",
  "_csrf_token":"rD35dsIoJyf5MIRA54/ARQNMBAN0yKvfMU4RjCc9WD8="
}
```

Vậy trong lần đầu request tới 1 website ruby on rails, nó sẽ tạo ra cho chúng ta 1 session, session lúc khởi tạo không có giá trị gì ngoài `session_id` và `_csrf_token`.

**Ủa sai sai, tôi nhớ là ngày xưa đi học được dạy rằng điểm khác biệt của session và cookies là session được lưu ở server còn cookies được lưu ở client cơ mà**

Đúng, tôi cũng được học như vậy, nhưng đó không phải là cách mà rails xử lý, `Rails được config mặc định là lưu session bằng cookies`, nếu không muốn ta có thể lưu trên `redis`, `database`... Tuy nhiên nếu không thấy ngại vì giới hạn không quá `4KB` của cookies thì tôi không thấy lý do gì để chuyển vị trí lưu trữ của session đi cả. :smiley:

Bây giờ tôi add thêm 1 giá trị vào session với câu lệnh `session[:user_id] = 1`, lúc này giá trị của cookies cũng thay đổi theo, lại decrypt ta thu được:

```ruby
{
  "session_id":"52cc440e209ad03d306e550c2ca2dd78",
  "_csrf_token":"rD35dsIoJyf5MIRA54/ARQNMBAN0yKvfMU4RjCc9WD8=",
  "user_id":1
}
```

Session bây giờ đã có thêm một key mới là `user_id` với giá trị là `1`. À vậy cuối cùng thì session cũng là 1 `hash` thôi nhỉ.

# Kết luận

Để phân biệt các client khác nhau, server sẽ dựa vào `session_id` được lưu trong cookies, vì vậy nếu chiếm được cookies đăng nhập trên website ABC.com của bạn, các hacker có thể dùng nó để giả mạo bạn và request lên server, đáng buồn thay server sẽ đọc cookies được hacker request lên, sử dụng `secret_key_base` để giải mã cookies và đọc nội dung bên trong, đoạn code xử lý login lại đọc từ session[:user_id], lúc này thì cookies kia có giá trị `session[:user_id] = 1` và thế là server đã tưởng rằng hacker chính là bạn.

Trong các bài tiếp theo chúng ta sẽ tìm hiểu về một số kiểu tấn công thông thường cũng như cách phòng tránh trong rails.
