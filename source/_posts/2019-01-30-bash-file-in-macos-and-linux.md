---
title: "Bash File Trên Unix"
date: 2018-12-30
draft: false
tags: ["unix"]
categories: ["hệ điều hành"]
mytag: "OS"
# mytop: "TOP VIEWS"
mytrend: "COOL"

---

# Đặt vấn đề

Đây lại là một bài viết tiếp theo về chủ đề liên quan đến các hệ điều hành và dòng lệnh. Khi mới tiếp xúc với máy tính, OS mà tôi sử dụng là windows, đến khi lên đại học, phần lớn thời gian học tập vẫn gắn liền với windows, còn phần nhỏ thời gian còn lại là làm quen với một hệ điều hành lạ lẫm mang tên Linux.

Việc cài đặt phần mềm trên Linux có khó khăn hơn windows một chút, đó là thay vì click chuột rồi next next next next... thì phần nhiều các phần mềm phục vụ công việc lập trình đều phải cài đặt qua dòng lệnh. Mọi thứ không có vấn đề gì cho đến khi việc copy những dòng lệnh đó rồi enter, bạn sẽ không còn nhận được một kết quả thành công mỹ mãn nữa mà thay vào đó là một đống lỗi được trả về.

Khi làm việc với Ruby, tôi đã từng gặp những lỗi liên quan đến Rbenv và RVM. Điều đó thực sự là một cơn ác mộng khi liên tục phải google tìm kiếm câu trả lời cho vấn đề gặp phải, copy những dòng lệnh trên stackoverflow paste vào terminal và chờ đợi rằng vấn đề sẽ được giải quyết dù chẳng hiểu dòng lệnh này có nghĩa là gì. Lâu dần tôi đã tích luỹ thêm được một số hiểu biết muốn chia sẻ mà bắt đầu là các File hệt thống.

# Luận bàn

Để bắt đầu chia sẻ về những file kể trên, có lẽ chúng ta sẽ phải điểm qua một số khái niệm cơ bản.

# 1.Một số khái niệm cơ bản.

`Unix` là một hệ điều hành ra đời đã rất lâu, nó là tiền thân của hai nhánh hệ điều hành rất nổi tiếng khác, bản thương mại chính là `macOS` và bản mã nguồn mở chính là `GNU`. Cho đến những năm 90, có một sự kết hợp giữa các phần mềm của `GNU` và phần core của một dự án mã nguồn mở khác tên là `Linux` đã tạo thành một hệ điều hành hoàn chỉnh mang tên là `GNU/Linux`, ngày nay đa số chúng ta chỉ thường gọi tắt là `Linux`

Qua đó chúng ta có thể thấy, `Linux` và các hệ điều hành con cháu của `Unix` có rất nhiều điểm chung.

`Shell`: Đây cũng là một khái niệm quan trọng cần tìm hiểu. Trước khi đi vào chủ đề chính của bài viết, để tìm hiểu một cách sâu sắc về Shell, có lẽ sẽ cần đến một bài viết khác, nên ở đây tôi chỉ mô tả một cách bao quát về nó. `Shell` là phần nằm giữa ứng dụng và phần core của hệ điều hành.

Hãy tưởng tượng chúng ta có một chồng sách gồm ba quyển với quyển trên cùng là những ứng dụng đang chạy trên máy tính của bạn vì dụ như word, excel, cuốn ở dưới cùng chính là phần nhân của hệ điều hành. Để các ứng dụng của bạn có thể sử dụng các tài nguyên của máy tính như bộ nhớ, ram, IO... điều tất yếu phải xảy ra đó là ứng dụng của bạn phải giao tiếp được với hệ điều hành.

Tuy nhiên, vấn đề gặp phải đó là hệ điều hành chỉ hiểu mã máy, một thứ quá phức tạp để người dùng khi sử dụng ứng dụng có thể thao tác được. Đó là lý do ra đời của “quyển sách” ở giữa mà chúng ta gọi là `Shell`. Nhiệm vụ của nó là gì? Đó là chuyển đổi các lệnh từ “quyển sách” đầu tiên thành các lệnh mà “quyển sách” thứ ba có thể hiểu và thực hiện được (Thông dịch).

Ví dụ terminal được xem là một `Shell CLI`, mỗi khi bạn gõ một lệnh bất kỳ trên terminal, nó sẽ chuyển đổi câu lệnh bạn viết thành một câu lệnh khác mà phần nhân hệ điều hành có thể hiểu và thực hiện được.

# 2.Điều gì xảy ra khi bạn gõ một lệnh trên terminal?

Đã bao giờ bạn tự hỏi chuyện gì sẽ xảy ra tiếp theo khi ta gõ một lệnh trong terminal? Ví dụ:

```ruby
ls -a
#=> Hiển thị tất cả file và folder nằm trong current folder.
```

Chúng ta sẽ thường tự an ủi bản thân rằng những câu lệnh đó đã được hệ điều hành lưu lại như một cuốn từ điển để đến khi được gọi chúng sẽ biết tìm câu trả lời ở đâu. Thực tế suy nghĩ trên không hẳn đã sai, mọi thứ trong Unix đều là file, nếu bạn gõ dòng lệnh:

```ruby
echo $PATH
```

Kết quả bạn nhận được chính là một danh sách các thư mục mà terminal sẽ tìm kiếm câu lệnh bạn gõ theo thứ tự từ trái qua phải. Với một hệ điều hành thuần khiết chưa cài đặt thêm các phần mềm bên ngoài thì PATH sẽ có giá trị mặc định như sau:

`/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`

Còn trên máy tính của tôi thì PATH lại có giá trị là:

`/Users/admin/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`

Có một sự khác biệt nhỏ, ta có thể thấy chuỗi PATH trên máy tính của tôi có phần đầu chuỗi được thêm bởi một thư mục .rbenv nào đó. Đây chính là mấu chốt của vấn đề, lý do xuất hiện của phần mở rộng nêu trên đó là tôi đã cài đặt thêm Ruby vào máy tính của mình bằng công cụ rbenv.

Hiển nhiên, khi hệ điều hành còn thuần khiết, nó không thể hiểu được câu lệnh `ruby – v`. Việc cài đặt Ruby vào máy tính đồng nghĩa với việc tôi đã tải các file liên quan vào một thư mục nào đó, và để chỉ cho terminal biết phải vào đâu để tìm kiếm các lệnh liên quan đến Ruby vừa cài đặt, chuỗi PATH sẽ được ghi đè bổ sung thêm đường dẫn vào thư mục chứa các file thực thi của Ruby. Từ đây, mỗi khi bạn gõ bất cứ một câu lệnh nào liên quan đến Ruby, terminal sẽ theo chuỗi PATH vào từng thư mục để tìm kiếm và thực thi câu lệnh đó.

Suy ra, có một lỗi rất hay xảy ra cho những người mới sử dụng Ruby, đó là họ thêm và xoá Ruby khá thường xuyên dẫn đến đường dẫn bị sai và terminal không thể tìm được thư mục có thể thực thi câu lệnh một cách chính xác.

Trong terminal, bạn có thể nối thêm một thư mục vào chuỗi PATH bằng câu lệnh sau:

`export PATH="$PATH:new_path"`

# 3.Một số file quan trọng trên Macos.

Khi quá trình làm việc với terminal nhiều hơn và chúng ta cần cài đặt một số thứ cần thiết trong quá trình làm việc, chúng ta sử dụng các `dot file`. Nội dung của các `dot file` này là các câu lệnh shell script (chức năng của câu lệnh này có thể chúng ta sẽ tìm hiểu sau).

Khi bạn mở một terminal mà nó đòi hỏi bạn phải login (ví dụ như khi bạn remote access vào một máy tính khác thông qua SSH, bạn cần nhập tên đăng nhập và mật khẩu) thì đó là một `Login Shell`.
Với trường hợp Login Shell thì `dot file` được load lên là file `.bash_profile`.
Trong một trường hợp khác, bạn mở một terminal mà không cần đăng nhập thì `dot file` được load là  `bashrc`.

Note: Khác với những người anh em khác, terminal trên Macos sẽ chạy `dot file` `.bash_profile` khi bạn mở một cửa sổ mới nên tôi thường đặt những cấu hình cần thiết vào một file duy nhất đó là `.bash_profile`. Tất nhiên, từ `.bash_profile` ta có thể load các `dot file` khác nếu cần thiết (chúng ta sẽ bàn về nó trong tương lai).

Thứ tự các `dot file` được khởi chạy trên macOS:

```ruby
#=> etc/profile
#=> etc/bashrc
#=> ~/.bash_profile
#=> ~/.bash_login (nếu ~/.bash_profile không tồn tại).
#=> ~/.profile (nếu ~/.bash_profile và ~/.bash_login đều không tồn tại).
```

# 4.Các file quan trọng trên Linux

Như đã trình bày ở trên, có một sự giống nhau đáng kể giữa `macOS` và `Linux`. Vì vậy, tôi chỉ có một số điều bổ sung như sau: Trên Linux, thông thường chúng ta sẽ có các `dot file` sau đây:

```ruby
#=> ~/.bash_login (chạy khi login shell)
#=> ~/.bashrc (chạy khi không login)
#=> ~/.bash_logout (chạy khi logout shell)
#=> ~/bash_history (lịch sử trên shell)
```

# Kết luận

Còn rất nhiều điều cần nói và bàn luận thêm trong các bài viết tiếp theo.
