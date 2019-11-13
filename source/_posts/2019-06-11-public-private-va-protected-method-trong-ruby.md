---
title: "Public, Private Và Protected"
date: 2019-06-11
draft: false
tags: ["ruby"]
categories: ["ruby notes"]
mytag: "Ruby"
mytrend: "COOL"

---

# Đặt vấn đề

Khi còn học đại học, chúng ta được học về tầm vực của các phương thức như sau:

1. Public phương thức, gọi ở đâu cũng được chỉ cần đảm bảo đã include cái class khai báo phương thức đó là được.

2. Protected phương thức, gọi ở chính class khai báo nó, ngoài ra còn có thẻ gọi ở các lớp kế thừa class khai báo phương thức này.

3. Private phương thức, gọi ở chính class mà nó được khai báo, ngoài ra...à mà quên không có ngoài ra, chỉ vậy thôi.

Những trích rút trên dựa theo ngôn ngữ mà chúng ta cùng theo đuổi ngày đại học C++. Vậy với Ruby? Liệu những phát biểu trên liệu còn đúng?

# Luận bàn

Không, những trích rút trên không còn đúng đắn hoàn toàn với ngôn ngữ Ruby. Có một số khác biệt. Trong bài viết này chúng ta sẽ đi sơ qua về nó.

"Mà sao lại là sơ qua? sao bài nào cũng dùng từ đi sơ qua mà không phải là "đíp đờ rai tu" gì đó, viết blog kiểu cơm nguội như này viết làm gì (angry)."

=> Vì đây không phải kiến thức cao siêu gì cả, có vô vàn tài liệu anh ngữ đề cập đến nó rồi và tôi không thấy cái lý do gì để cố đọc tài liệu thật nhiều, translate thật đã tay, rồi vietsub ra một bài viết dài như sông Hồng để nói về một chủ đề vô cùng normal để thể hiện bản thân cả :smile:

# Lấy một ví dụ

```ruby
class Cat
  # default public method
  def cat_hello_public
    puts "T*o ngao ngao public mot cach quy toc"
  end

  protected

  def cat_hello_protected
    puts "T*o ngao ngao protected mot cach sexy"
  end

  private

  def cat_hello_private
    puts "T*o ngao ngao private mot  cach len lut"
  end
end
```

Ra ngoài scope của class này rồi chạy:

```ruby
Cat.new.cat_hello_public
# => T*o ngao ngao public mot cach quy toc.
Cat.new.cat_hello_protected
# => error
Cat.new.cat_hello_private
# => error
```

**Note:** public có thể gọi ngoài tầm vực của một class, những method còn lại thì không. Đồng nghĩa với việc bạn chỉ cần đảm bảo ref được file chưa class có phương thức public đó thì bạn có thể thoải mái gọi phương thức này.

# Thêm một class con kế thừa

```ruby
class YellowCat < Cat; end
```

Chạy:

```ruby
YellowCat.new.cat_hello_public
# => T*o ngao ngao public mot cach quy toc.
```

**Note:** Phương thức public có thể được gọi công khai bởi class kế thừa của class chưa phương thức đó.

# Gọi 3 phương thức Cat trong một method thuộc YellowCat

```ruby
class YellowCat < Cat
  def yellow_cat
    cat_hello_public
    cat_hello_protected
    cat_hello_private
  end
end
```

Chạy:

```ruby
YellowCat.new.yellow_cat
# => T*o ngao ngao public mot cach quy toc
# => T*o ngao ngao protected mot cach sexy
# => T*o ngao ngao private mot  cach len lut
```

**Note:** Cả 3 dạng phương thức đều có thể được gọi trong lớp con (Trong lớp con nhé).

# Trong phương thức yellow_cat khai báo một đối tượng Cat và gọi tới 3 phương thức

```ruby
class YellowCat < Cat
  def yellow_cat
    cat = Cat.new
    cat.cat_hello_public
    cat.cat_hello_protected
    cat.cat_hello_private
  end
end
```

Chạy:

```ruby
YellowCat.new.yellow_cat
# => T*o ngao ngao public mot cach quy toc
# => T*o ngao ngao protected mot cach sexy
# =>  error
```

:arrow_right: **Note:** Trong một lớp con kế thừa từ lớp cha, public và protected method của lớp cha có thể được lớp con access thông qua `implicit receiver` and `explicit receiver`. Còn private method thì chỉ có thể được access thông qua `implicit receiver`.

:one: **Implicit receiver**: Không chỉ định đối tượng sẽ thực hiện phương thức.

:two: **Explicit receiver**: Chỉ định rõ ràng đối tượng sẽ thực hiện phương thức.

# Kết luận

Nếu có đóng góp về bài viết hoặc ghét thái độ tác giả viết bài sơ sài hời hợt thì hãy để lại bình luận nhé.
