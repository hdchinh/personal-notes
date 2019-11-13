---
title: "Permission Trong Unix Là Gì?"
date: 2018-01-01
draft: false
tags: ["unix"]
categories: ["hệ điều hành"]
mytag: "OS"
mytrend: "COOL"

---

# Đặt vấn đề

Phần lớn thời gian thời đại học, tôi được học trên nền tảng window với bộ công cụ visual studio và ms sql server. Mọi thứ đều ổn cho đến khi ra trường và đi làm. Môi trường làm việc không còn là window nữa mà chuyển sang gia đình linux-unix. Rất nhiều thứ lạ lẫm, tuy nhiên, cũng như nhiều lập trình viên khác. Copy paste không có gì khó khăn với tôi.

Từ những tutorial trên mạng, với những dòng lệnh tôi không hiểu, nhưng đâu thành vấn đề gì? Nó đang chạy và vậy là đã đủ hạnh phúc cho một cậu lập trình viên thiếu kinh nghiệm mới ra trường rồi. Tuy nhiên, việc phải làm những công việc lặp đi lặp lại hàng ngày mà không thực sự hiểu chúng khiến chúng ta khó chịu. Chẳng hạn như những câu lệnh set permission chẳng hạn.

# Luận bàn

# 1.File permission là gì?

Tương tự như ngôi nhà của bạn, bạn sống cùng gia đình và thi thoảng có những vị khách ghé thăm. Có những vật dụng trong nhà mà bạn chỉ muốn riêng mình bạn có thể sử dụng, cũng có những đồ vật khác, thứ mà chỉ bạn và gia đình được phép sử dụng, và cũng có những đồ vật mà bạn, gia đình và cả những vị khách đều có thể sử dụng.

Tài nguyên trong unix tương tự như vậy, mọi thứ trong unix đều là file. Vậy nên có những file quan trọng chỉ mình bạn có thể xài, cũng có những file mà bạn có thể chia sẻ thêm cho 1 nhóm nào đó. Còn những thứ không quá quan trọng bạn có thể mở cửa cho ai cũng có thể sử dụng.

=> Đó là lý do permission cần tồn tại.

# 2.Sử dụng là sử dụng thế nào?

Hiểu đơn giản như thế này, nhà của bạn, bạn cho tôi vào và cho phép tôi ngồi ghế uống nước xem tivi, nhưng không đồng nghĩa với việc tôi muốn làm gì cái ghế hay cái tivi cũng được. Tôi chỉ có thể sử dụng chứ không được phép thay đổi hay đập phá đồ đạc của bạn.

Trong unix có 3 quyền sử dụng:

1. Quyền đọc.
2. Quyền ghi.
3. Quyền thực thi.

# 3.Các loại người dùng.

1. Owner (người sở hữu file đó - người tạo ra file đó).
2. Group (nhóm sở hữu file).
3. Other (phần còn lại của hệ thống có thể là guest).

| Ngoài ra trên unix thì còn 1 người dùng thứ 4 gọi là root. Đây là người dùng siêu quyền lực và không thể bị ảnh hưởng bởi mấy lệnh phân quyền của bạn

Hiểu đơn giản như việc bạn ở nhà của mình và nghĩ bạn có thể làm mọi việc với căn nhà đó mà không ai có thể can thiệp. Tuy nhiên khi mở sổ đỏ ra thì bạn sẽ thấy là bạn chỉ đang có quyền sử dụng đất chứ không phải sở hữu đất. Mọi đất đai đều thuộc quyền sở hữu của nhà nước.

Đây chính là root trong trường hợp này, và nếu nhà nước thích thì quyền sở hữu nhà hay mọi tài nguyên trong nhà của bạn có thể bay màu.

| Vì vậy hãy thật cẩn thận khi sử dụng quyền root trên máy tính. Trong trường hợp máy tính, thì chúng ta là chủ sở hữu nên chúng ta có thể enable hay disable root đi. Trên Mac thì mặc định là disable.

# 4.Cách phân quyền

`chmod xyz file/folder`

Ví dụ:  `chmod 007 duychinh.bin`

Giải thích câu lệnh trên:
-xyz là 3 số nguyên liền nhau( giá trị của ba số này có thể là 0,1,2,3,4,5,6,7).
Với x ứng với quyền phân cho owner, y ứng với quyền phân cho group và z là cho everyone.

:zero: không có quyền gì cả.

:one: quyền thực thi tập tin.

:two: quyền write only.

:four: quyền read only.

Với 4 số trên ta có thể cộng lại và ra 1 số mới với permission được cộng dồn.
Ví dụ: 7 = 4 + 2 + 1 => tất cả các quyền. Tương tự với cả tổ hợp khác.

Suy ra với lệnh `chmod 777 file_name` --> Ta đã gán tất cả quyền cho cả 3 loại user(như liệt kê ở mục 3).

Hình ảnh minh hoạ:

![Branching](http://www.macinstruct.com/images/permissions/permissions1.png)

Trong nhiều trường hợp để có thể thực hiện được lệnh set permission kể trên, ta phải thêm câu lệnh `sudo`
vào phía trước. Trong các bài tiếp theo sẽ giải thích về ý nghĩa của câu lệnh này.

# 5.Tham khảo

[1] [guru99](https://www.guru99.com/file-permissions.html)

# Kết luận

Trên là 1 cái nhìn tổng quan về phân quyền trên linux. Thế giới unix còn rất nhiều điều thú vị, hi vọng trong thời gian tôi có thể có thời gian để tìm hiểu sâu sắc hơn về nền tảng này.

![File Permission](/images/file_permission.gif)
