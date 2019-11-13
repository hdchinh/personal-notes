---
title: "Root, Sudo Và Package Management"
date: 2019-02-05
draft: false
tags: ["unix"]
categories: ["hệ điều hành"]
mytag: "OS"
mytrend: "COOL"
---

# Đặt vấn đề

Trong một bài viết gần đây về chủ đề file permission trên Unix/Linux, tôi có đề cập đến một người dùng quyền lực trên các hệ thống kể trên có tên gọi là `root`. Bài viết này sẽ khái quát về người dùng này kèm theo hai khái niệm có liên quan là `sudo` và `Package Management System`.

# Luận bàn

# 1.Root

Xin được nhắc lại một câu chuyện cũ tôi đã kể trong bài viết trước với ví dụ về mảnh đất nhà bạn, bạn sở hữu mảnh đất đó, vợ bạn sở hữu mảnh đất đó chung với bạn. Nhưng vợ chồng bạn không phải là những người sở hữu tối thượng của mảnh đất kể trên, mà quyền lực to lớn này thuộc về nhà nước, “người” thực ra là đang cho bạn thuê đất có thời hạn. Tương tự trọng Unix/Linux, sẽ có những user (như tài khoản bạn sử dụng để đăng nhập, hoặc tài khoản khách…).

Việc những tài khoản này có thể đăng nhập vào hệ thống nhưng đặc quyền của chúng bị giới hạn. Khi login vào hệ thống, bạn có thể làm một số tác vụ nhất định chứ không thể thích làm gì thì làm, trong hệ thống của bạn chỉ có một user duy nhất được quyền làm bất cứ điều gì, đó là một super user.

Trên windows, ta gọi đó là `administrator` (có lẽ quá quen thuộc, bạn còn nhớ những lúc cài phần mềm, bạn click vào file exe nhưng chương trình không chịu cài đặt, google một lát, bạn nhận được một hướng dẫn hãy click phải vào file exe đó và chọn `run as administrator`, đó chính là sức mạnh của super user trên windows), còn trên macOS hay Ubuntu(1 đại diện của Linux), nó được gọi là `root` (cuối cùng cũng chỉ là một cái tên gọi, nó có thể được đặt tên là mèo, là chó, nó có thể được đặt tên là bất cứ thứ gì, chúng ta không cần quan tâm, điều duy nhất chúng ta cần biết đó là trên các hệ điều hành con cháu của Unix sẽ luôn có một super user quyền lực như vậy).

Đến lúc này, bạn sẽ tự hỏi tại sao phải thiết kế hệ thống phức tạp như vậy? Tại sao không chỉ dung duy nhất một loại user?
Câu trả lời rất đơn giản, không phải ai sử dụng máy tính cũng là những người dung có hiểu biết sâu sắc về hệ điều hành. Vì vậy, nếu trao cho họ những quyền lực quá lớn, họ có thể vô tình gây ra những huỷ hoại nghiêm trọng cho hệ thống (quyền lực càng lớn thì trách nhiệm càng lớn).

Một vấn đề phát sinh nếu việc sử dụng Root mang tính rủi ro quá cao nhưng những user bình thường lại không có các quyền để cài đặt một số phần mềm nâng cao thì phải làm sao? Vấn đề này sẽ được giải thích ở mục số 2.

Note: Trên macOS và Ubuntu, `root` mặc định sẽ được disable, chúng có thể sẽ được enable trở lại và re-disable. Cách thực hiện thì có lẽ bạn nên tìm kiếm hướng dẫn từ trang chủ của những hệ điều hành này để câu lệnh của bạn đảm bảo chính xác và không bị lỗi thời.

# 2.Sudo

Như vấn đề tôi đã nêu ở cuối mục 1, bây giờ tôi muốn cài đặt một số phần mềm đòi hỏi quyền của super user, về lý thuyết tôi đứng giữa hai lựa chọn hoặc chuyển sang `root` và cài đặt phần mềm bình thường (rất rủi ro), phương án 2 là tôi vẫn sử dụng user thường và nói lời tạm biệt với những phần mềm kể trên.

Quá tệ, cả hai giải pháp trên đều không ổn, thật may, các nhà phát triển hệ thống đã cung cấp cho chúng ta một lựa chọn số 3, đó là bạn vẫn sử dụng user thường nhưng có thể triệu hồi quyền lực của super user để thực hiện những lệnh nào đó.

Cách sử dụng đó là bạn thêm câu lệnh `sudo` vào phía trước câu lệnh cần sử dụng quyền của super user. Ví dụ:

`sudo apt-get update`

Một nhầm lẫn thường xuyên với cả với tôi ngày mới tìm hiểu, đó là sau khi gõ những câu lệnh có `sudo`, hệ thống yêu cầu tôi nhập mật khẩu và tôi đã từng nghĩ đó là mật khẩu của `root` (nghe cũng hợp lý đấy chứ, ta mượn quyền của `root` thì phải sử dụng mật khẩu của `root` chứ nhỉ? Giống như khi tôi mượn nhà của bạn thì tôi phải có chìa khoá của bạn). Nhưng không phải như vậy, mật khẩu bạn nhập vào đơn thuần là chính mật khẩu của user thường bạn đang login trên máy.

Phần đa các trường hợp khi bạn thêm `sudo`, các câu lệnh sẽ chạy một cách hoàn hảo. Tuy nhiên, cũng có những khi bạn không nhận được kết quả như mong đợi và lý do chính là không phải user nào cũng có thể triệu hồi quyền lực của super user. Điều bạn cần làm khi đó là "nói" với hệ điều hành rằng hãy cho user của tôi đang sử dụng được quyền triệu hồi sức mạnh của super user. Hãy xem ví dụ dưới đây:

```ruby
#=> /etc/sudoers (lưu trữ các user được quyền thực hiện đặc quyền của super user)
#=> Ví dụ
root ALL=(ALL:ALL) ALL
#=> user đang xét quyền tên là root
#=> Chữ all đầu tiên chỉ ra rằng rule này được áp dụng cho tất cả các host
#=> Chữ all thứ hai chỉ ra, account root có thể chạy lệnh với quyền của bất kỳ user nào.
#=> Chữ all thứ ba chỉ ra, account root có thể chạy lệnh với quyền của bất kỳ group nào.
#=> Chữ all cuối cùng chỉ ra, account root có thể chạy bất kỳ command nào.
```

Note: Kể từ khi bạn nhập mật khẩu sau khi gõ lệnh `sudo` lần đầu, thời gian có hiệu lực của mật khẩu này sẽ là 15 phút. Trong khoảng thời gian đó bạn có thể chạy các lệnh `sudo` khác mà hệ điều hành không yêu cầu bạn nhập lại mật khẩu.


# 3.Package management system

Khi sử dụng macOS, để cài đặt thêm các phần mềm phục vụ công việc (mà chúng không được support trên appstore), tôi sử dụng `homebrew`, một phần mềm giúp quản lý các phần mềm khác rất hiệu quả.

Vậy còn trên Linux chúng ta có gì?

Trước hết cần phải làm rõ: Package management system là một công cụ hoặc một hệ thống các công cụ được sử dụng để handle các package.
1.	Handle là quản lý với đầy đủ các chức năng như thêm mới, gỡ bỏ, nâng cấp, tìm kiếm..v..v…
2.	Package là một tiện ích hoặc những phần bổ trợ cho một tiện ích nào đó (thực sự cuối cùng nó cũng chỉ là tập hợp của các file).

Một `Package Management System` nổi tiếng trên Linux đó là `DPKG`, nó là một công cụ để cài đặt các package có đuôi .deb (các package dành cho các hệ điều hành thuộc dòng debian).
Nhiệm vụ của `DPKG` là install hoặc remove một package (với điều kiện các file cần thiết đã có trên local).

Đến đây nhiều bạn có thể thắc mắc rằng từ trước đến giờ bạn chưa hề sử dụng các dòng lệnh liên quan đến `DPKG`, vậy tại sao tôi lại bảo là nó rất phổ biến? Câu trả lời đó là bạn đang sử dụng các phần mềm package management system khác được xây dựng dựa trên phần core là `DPKG`, một trong số đó là `APT–GET/APT`.

Ưu điểm lớn nhất của `APT` so với `DPKG` đó là `DPKG` chỉ có thể cài đặt file khi mà file đó đã có trên local (tức là bằng cách nào đó bạn phải download hoặc copy file đó về máy của bạn). Còn với `APT`, nó sẽ tìm kiếm các package đó từ `remote repositories`, sau đó download chúng về máy.

Điểm mạnh thứ hai của `APT` so với `DPKG` đó là nó giải quyết được bài toán dependencies. Nếu package bạn cần cài đặt phụ thuộc vào một vài package khác, nếu sử dụng `DPKG` thì bạn sẽ phải cài đặt tất cả các package kể trên một cách thủ công.
Còn với `APT`, nó sẽ tự hiểu được package đó cần thêm những phụ trợ nào và tự động cài đặt phần phụ trợ.

Điều thật sự diễn ra đó là trong `APT`, `DPKG` vẫn tồn tại. Nó tồn tại ở một cấp thấp hơn và thực hiện các chỉ thị của `APT`.

Note: Các `remote repositories` để phần mềm package management của bạn tìm kiếm sẽ được lưu trữ trong file `/etc/apt/sources.list` (đa số là như vậy).

# Kết luận

Còn rất nhiều điều cần nói và bàn luận thêm trong các bài viết tiếp theo.
