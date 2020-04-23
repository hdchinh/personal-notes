---
title: "Exception Trong Rails [Part 2]"
date: 2020-04-23
tags: ["RUBY"]
---

## 1. Xử lý exception trong method

E.g. Trong products_controller.rb ta có method sau:

```ruby
  def show
    product = Product.find(12)

    render layout_for_product_detail
  end
```

Nếu không có product nào có id = 12, đoạn code trên sẽ gặp lỗi, và người dùng sẽ nhận được 1 màn hình error server.

Không muốn điều này xảy ra, ta update lại đoạn code như sau:

```ruby
def show
  begin
    product = Product.find(12)

    render layout_for_product_detail
  rescue StandardError => e
    # Do something good for user
  end
end
```

Vậy là ổn, như trong bài phần 1, catch exception với StandardError là đủ tốt để áp dụng và có lẽ đủ tốt để pass review code.

## 2. Xử lý exception với controller

Phần 1 đã ổn, nhưng không được tốt, lý do là vì nếu chúng ta có 100 methods, vậy chúng ta sẽ lắp lại đoạn catch exception kia 100 lần. Không DRY chút nào, viết 1 chục method lặp lại cùng 1 exception thì có lẽ không pass được review code =))

Update: products_controller.rb

```ruby
class ProductsController < ApplicationController
  rescue_from StandardError, with: :private_method_you_use_to_handle_exception

  def show
    product = Product.find(12)

    render layout_for_product_detail
  end

  # 100 methods nữa ở đây...

  private

  def private_method_you_use_to_handle_exception
    # Do something good
  end
end
```

Như vậy đỡ phải viết lặp đi lặp lại 100 lần. Có vẻ tốt hơn rồi, tuy nhiên đã đủ tốt?

## 3. Xử lý exception với controller cha

Vậy nếu ta có 100 controller, và chỉ để bắt StandardError mà chúng ta phải viết rescue_from cho cả 100 controller đó?

Ta có thể xử lý trường hơp trên bằng cách dùng rescue_from trong controller cha, ở đây thì cha của products controller là application controller.

```ruby
class ApplicationControler < ActionController::Base
  rescue_from StandardError, with: :private_method_you_use_to_handle_exception

  private

  def private_method_you_use_to_handle_exception
    # Do something good
  end
end

class ProductsController < ApplicationController
  def show
    product = Product.find(12)

    render layout_for_product_detail
  end
end
```

## 4. Tách exception ra module riêng

Giờ chúng ta chỉ có 1 exception cơ bản, nhưng không gì đảm bảo được rằng thế giới quan ngoài kia có thể kìm hãm nổi tài năng của bạn, rất có thể vài năm sau project làm chơi ngày nào của bạn thành startup triệu đô? =)) logic và bussiness lúc đó phức tạp thêm chục/trăm/ngàn lần.

Nên tách exception handle sang 1 module riêng là lựa chọn không tồi cho hiện tại và là lựa chọn không thể tránh khỏi trong tương lai (project của bạn mập lên).

Bạn muốn tách moudle này vào đâu? tôi không biết, tôi thì bỏ vào concerns folder của folder controller cho nhanh.

```ruby
# controllers/concerns/handle_exception.rb
module HandleException
  included do
    rescue_from StandardError do |e|
      # Do something good
    end
 end
end

class ApplicationControler < ActionController::Base
  include HandleException
end

```

Vậy là chúng ta đã tách đoạn logic xử lý exception ra khỏi controller.

## 5. Bắt exception chi tiết hơn

Đến mục số 4, mọi thứ đã khá tốt, tuy vậy, có nhiều exception trong rails (và framework nào cũng vậy). Standard là 1 exception rất chung chung, vì vậy chỉ bắt Standard exception có lẽ giành cho trường hợp chúng ta... lười, hoặc dự án không nhiều logic, hoặc không đủ thời gian để implement, deadline dí quá chạy không kịp, nên chạy được là tốt rồi chứ chả còn thời gian mà nghĩ đến exception tốt hay chưa.

Trong trường hợp bạn...rảnh hoặc dự án yêu cầu, hoặc leader khó tính, chúng ta nên bắt các exception chi tiết hơn và chỉ nên cover Standard sau cùng.


```ruby
# controllers/concerns/handle_exception.rb
module HandleException
  included do
    # Exception 1
    rescue_from StandardError do |e|
      # Do something good
    end

    # Exception 2
    rescue_from ActiveRecord::RecordNotFound do |e|
      # Do something good
    end

    # ... N exception nữa, tuỳ nhu cầu của bạn.
 end
end

class ApplicationControler < ActionController::Base
  include HandleException
end

```

> Theo thứ tự included, exception khai báo sau sẽ được gọi trước, vậy exception 2 sẽ được gọi trước exception 1. Do đó nên khai báo cho Standard exception làm exception đầu tiên.

## 6. Tạo thêm các lớp exception

Giả sử với lượng exception mặc định trong rails không đủ cho project tầm cỡ 4.0 của bạn? bạn muốn catch những exception đặc biệt mà bạn chỉ bạn nghĩ ra?

Chúng ta có thể tạo thêm các class exception để đáp ứng nhu cầu trên:

```ruby
# controllers/concerns/handle_exception.rb
module HandleException
  # Khái báo class exception bạn tạo,
  # chúng đều kế thừa từ class StandardError
  class WeakPassword < StandardError; end

  included do
    # Exception 1
    rescue_from StandardError do |e|
      # Do something good
    end

    # Exception 2
    rescue_from ActiveRecord::RecordNotFound do |e|
      # Do something good
    end


    # Exception 3
    rescue_from HandleException::WeakPassword do |e|
      # TODO: notification password too weak
      # TODO: init recommmend password
      # TODO: display recommend password for UI
    end

    # ... N exception nữa, tuỳ nhu cầu của bạn.
 end
end

class ApplicationControler < ActionController::Base
  include HandleException
end

```

Như vậy, khi bạn validate mật khẩu của user submit lên, nếu không thoả mãn điều kiện là một mật khẩu đủ mạnh, **raise** exception đã khai báo.

## 7. Xử lý exception trong method

Lại quay lại bước 1, nhưng không phải chúng ta xử lý mọi exception trong từng method. Mà khi chúng ta có 1 đoạn logic đặc biệt, không lặp lại, và có tính quan trọng thì chúng ta nên catch exception ngay tại chỗ đoạn logic đó diễn ra:

1. dễ đọc code
2. vì là 1 trường hợp logic quan trọng nên cũng cần những xử lý exception có thể quan trọng theo, chứ không chỉ là bắn bug ra terminal hay ghi log.

```ruby
class ChargesController < ApplicationController
  def important_method
    begin
      payment_intent = Stripe::PaymentIntent.create(
        :amount => source.amount,
        :currency => source.currency,
        :source => source.id,
        :payment_method_types => [source.type],
        :description => "PaymentIntent for Source webhook",
        :confirm => true,
        :capture_method => ENV['CAPTURE_METHOD'] == "manual" ? "manual" : "automatic",
      )
    rescue Stripe::StripeError => e
      status 400
      return log_info("Webhook: Error creating PaymentIntent: #{e.message}")
    end
  end
end
```

> Đoạn code trên được copy từ [stripe sample code](https://github.com/stripe/example-mobile-backend/blob/master/web.rb)

Như ví dụ trên, khi bạn xử dụng thư viện, hoặc api của bên thứ 3, có những exception đặc trưng cho từng loại thư viện, làm theo docs của thư viện đó thôi, nên bắt các exception ngay tại nơi logic đang diễn ra. Sau có dục thư viện đó đi hay update thì cũng dễ xử lý hơn.

## 8. Ghi log

Cuối cùng, khi sản phẩm của bạn lên production, bạn cần ghi log, để đọc, truy vết điều tra lỗi khi cần.

Tôi hiện viết log theo cách sau:

```ruby
# controllers/concerns/handle_log.rb
module HandleLog
  def write_log(e)
    issue = "START: ---------------------------\n"
    issue << "TIME: #{Time.now.utc} \n"
    issue << "PARAMS: #{params.to_json} \n"
    issue << "MESSAGE: #{e.message}\n"
    issue << "----------------------------- :END\n"

    Rails.logger.info issue
  end
end

# controllers/concerns/handle_exception.rb
module HandleException
  # Khái báo class exception bạn tạo,
  # chúng đều kế thừa từ class StandardError
  class WeakPassword < StandardError; end

  included do
    # Exception 1
    rescue_from StandardError do |e|
      # Do something good
      write_log(e)
    end

    # Exception 2
    rescue_from ActiveRecord::RecordNotFound do |e|
      # Do something good
      write_log(e)
    end


    # Exception 3
    rescue_from HandleException::WeakPassword do |e|
      # TODO: notification password too weak
      # TODO: init recommmend password
      # TODO: display recommend password for UI
    end

    # ... N exception nữa, tuỳ nhu cầu của bạn.
 end
end

class ApplicationControler < ActionController::Base
  include HandleLog
  include HandleException
end
```

## 9. Tham khảo

[1] [http://rubylearning.com/satishtalim/ruby_exceptions.html](http://rubylearning.com/satishtalim/ruby_exceptions.html)
