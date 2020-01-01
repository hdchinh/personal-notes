---
title: "Bash File Trên UNIX"
date: 2018-12-30
draft: false
tags: ["UNIX"]
categories: ["OS"]
mytag: "OS"

---

## 1.Một số khái niệm cơ bản.

**UNIX** là một hệ điều hành ra đời đã rất lâu, nó là tiền thân của hai nhánh hệ điều hành rất nổi tiếng khác, bản thương mại chính là **macOS** và bản mã nguồn mở chính là **GNU**. Cho đến những năm 90, có một sự kết hợp giữa các phần mềm của **GNU** và phần core của một dự án mã nguồn mở khác tên là **Linux** đã tạo thành một hệ điều hành hoàn chỉnh mang tên là **GNU/Linux**, ngày nay đa số chúng ta chỉ thường gọi tắt là **Linux**

Qua đó chúng ta có thể thấy, **Linux** và các hệ điều hành con cháu của **UNIX** có rất nhiều điểm chung.

**Shell**: Đây cũng là một khái niệm quan trọng cần tìm hiểu. Trước khi đi vào chủ đề chính của bài viết, để tìm hiểu một cách sâu sắc về Shell, có lẽ sẽ cần đến một bài viết khác, nên ở đây tôi chỉ mô tả một cách bao quát về nó. **Shell** là phần nằm giữa ứng dụng và phần core của hệ điều hành.

Hãy tưởng tượng chúng ta có một chồng sách gồm ba quyển với quyển trên cùng là những ứng dụng đang chạy trên máy tính của bạn vì dụ như word, excel, cuốn ở dưới cùng chính là phần nhân của hệ điều hành. Để các ứng dụng của bạn có thể sử dụng các tài nguyên của máy tính như bộ nhớ, ram, IO... điều tất yếu phải xảy ra đó là ứng dụng của bạn phải giao tiếp được với hệ điều hành.

Tuy nhiên, vấn đề gặp phải đó là hệ điều hành chỉ hiểu mã máy, một thứ quá phức tạp để người dùng khi sử dụng ứng dụng có thể thao tác được. Đó là lý do ra đời của “quyển sách” ở giữa mà chúng ta gọi là **Shell**. Nhiệm vụ của nó là gì? Đó là chuyển đổi các lệnh từ “quyển sách” đầu tiên thành các lệnh mà “quyển sách” thứ ba có thể hiểu và thực hiện được (Thông dịch).

Ví dụ terminal được xem là một **Shell CLI**, mỗi khi bạn gõ một lệnh bất kỳ trên terminal, nó sẽ chuyển đổi câu lệnh bạn viết thành một câu lệnh khác mà phần nhân hệ điều hành có thể hiểu và thực hiện được.

## 2.Điều gì xảy ra khi bạn gõ một lệnh trên terminal?

Đã bao giờ bạn tự hỏi chuyện gì sẽ xảy ra tiếp theo khi ta gõ một lệnh trong terminal? Ví dụ:

```
ls -a
```

Chúng ta sẽ thường tự an ủi bản thân rằng những câu lệnh đó đã được hệ điều hành lưu lại như một cuốn từ điển để đến khi được gọi chúng sẽ biết tìm câu trả lời ở đâu. Thực tế suy nghĩ trên không hẳn đã sai, mọi thứ trong UNIX đều là file, nếu bạn gõ dòng lệnh:

```
echo $PATH
```

Kết quả bạn nhận được chính là một danh sách các thư mục mà terminal sẽ tìm kiếm câu lệnh bạn gõ theo thứ tự từ trái qua phải. Với một hệ điều hành thuần khiết chưa cài đặt thêm các phần mềm bên ngoài thì **PATH** sẽ có giá trị mặc định như sau:

```
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Còn trên máy tính của tôi thì PATH lại có giá trị là:

```
/Users/admin/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Có một sự khác biệt nhỏ, ta có thể thấy chuỗi **PATH** trên máy tính của tôi có phần đầu chuỗi được thêm bởi một thư mục .rbenv nào đó. Đây chính là mấu chốt của vấn đề, lý do xuất hiện của phần mở rộng nêu trên đó là tôi đã cài đặt thêm Ruby vào máy tính của mình bằng công cụ rbenv.

Hiển nhiên, khi hệ điều hành pure (chưa có cài đặt gì khác các ứng dụng mặc định), thì nó không thể hiểu được câu lệnh **ruby – v**. Việc cài đặt Ruby vào máy tính đồng nghĩa với việc tôi đã tải các file liên quan vào một thư mục nào đó, và để chỉ cho Terminal biết phải vào đâu để tìm kiếm các lệnh liên quan đến Ruby vừa cài đặt, chuỗi **PATH** sẽ được ghi đè bổ sung thêm đường dẫn vào thư mục chứa các file thực thi của Ruby. Từ đây, mỗi khi bạn gõ bất cứ một câu lệnh nào liên quan đến Ruby, terminal sẽ theo chuỗi **PATH** vào từng thư mục để tìm kiếm và thực thi câu lệnh đó.

Suy ra, có một lỗi rất hay xảy ra cho những người mới sử dụng Ruby, đó là họ thêm và xoá Ruby khá thường xuyên dẫn đến đường dẫn (**PATH**) bị sai và Terminal không thể tìm được thư mục có thể thực thi câu lệnh một cách chính xác.

Trong Terminal, bạn có thể nối thêm một thư mục vào chuỗi **PATH** bằng câu lệnh sau:

**export PATH="$PATH:new_path"**

## 3.Một số file quan trọng trên Macos.

Khi quá trình làm việc với terminal nhiều hơn và chúng ta cần cài đặt một số thứ cần thiết trong quá trình làm việc, chúng ta sử dụng các **dot file**. Nội dung của các **dot file** này là các câu lệnh shell script (chức năng của câu lệnh này có thể chúng ta sẽ tìm hiểu sau).

Khi bạn mở một terminal mà nó đòi hỏi bạn phải login (ví dụ như khi bạn truy cập vào một máy tính khác thông qua SSH, bạn cần nhập tên đăng nhập và mật khẩu) thì đó là một **Login Shell**.
Với trường hợp Login Shell thì **dot file** được load lên là file **.bash_profile** (hay là **.profile** ở trên Ubuntu).
Trong một trường hợp khác, bạn mở một terminal mà không cần đăng nhập thì **dot file** được load là  **.bashrc**.

Note: Khác với những người anh em khác, terminal trên Macos sẽ chạy **dot file** **.bash_profile** khi bạn mở một cửa sổ mới nên tôi thường đặt những cấu hình cần thiết vào một file duy nhất đó là **.bash_profile**. Tất nhiên, từ **.bash_profile** ta có thể load các **dot file** khác nếu cần thiết (chúng ta sẽ bàn về nó trong tương lai).

Thứ tự các **dot file** được khởi chạy trên macOS:

```
#=> etc/profile
#=> etc/bashrc
#=> ~/.bash_profile
#=> ~/.bash_login (nếu ~/.bash_profile không tồn tại).
#=> ~/.profile (nếu ~/.bash_profile và ~/.bash_login đều không tồn tại).
```

## 4.Các file quan trọng trên Linux

Như đã trình bày ở trên, có một sự giống nhau đáng kể giữa **macOS** và **Linux**. Vì vậy, tôi chỉ có một số điều bổ sung như sau: Trên Linux, thông thường chúng ta sẽ có các **dot file** sau đây:

```
#=> ~/.bash_login (chạy khi login shell)
#=> ~/.bashrc (chạy khi không login)
#=> ~/.bash_logout (chạy khi logout shell)
#=> ~/bash_history (lịch sử trên shell)
```
