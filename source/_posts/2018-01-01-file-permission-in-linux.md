---
title: "Tổng Quan Về Permission Trong UNIX"
date: 2018-01-01
draft: false
tags: ["UNIX"]
categories: ["OS"]

---

## 1.File permission là gì?

Tương tự như ngôi nhà của bạn, bạn sống cùng gia đình và thi thoảng có những vị khách ghé thăm. Có những vật dụng trong nhà mà bạn chỉ muốn riêng mình bạn có thể sử dụng, cũng có những đồ vật khác, thứ mà chỉ bạn và gia đình được phép sử dụng, và cũng có những đồ vật mà bạn, gia đình và cả những vị khách đều có thể sử dụng.

Tài nguyên trong UNIX tương tự như vậy, mọi thứ trong UNIX đều là file. Vậy nên có những file quan trọng chỉ mình bạn có thể xài, cũng có những file mà bạn có thể chia sẻ thêm cho 1 nhóm nào đó. Còn những thứ không quá quan trọng bạn có thể mở cửa cho ai cũng có thể sử dụng.

> Đó là lý do permission cần tồn tại. Cho 1 người được đụng vào thứ mà họ được phép đụng vào. Không hơn, mục tiêu cao cả là vậy.

## 2.Sử dụng là sử dụng thế nào?

Hiểu đơn giản như thế này, nhà của bạn, bạn cho tôi vào và cho phép tôi ngồi ghế uống nước xem tivi, nhưng không đồng nghĩa với việc tôi muốn làm gì cái ghế hay cái tivi cũng được. Tôi chỉ có thể sử dụng chứ không được phép thay đổi hay đập phá đồ đạc của bạn.

Trong UNIX có 3 quyền sử dụng:

1. Quyền đọc (read).
2. Quyền ghi (write).
3. Quyền thực thi (excute).

## 3.Các loại người dùng.

1. Owner (người sở hữu file đó - người tạo ra file đó).
2. Group (nhóm sở hữu file).
3. Other (phần còn lại của hệ thống có thể là guest).

> Ngoài ra trên UNIX thì còn 1 người dùng thứ 4 gọi là root. Đây là người dùng siêu quyền lực và không thể bị ảnh hưởng bởi mấy lệnh phân quyền của bạn

Hiểu cơ bản như việc bạn ở nhà của mình và nghĩ bạn có thể làm mọi việc với căn nhà đó mà không ai có thể can thiệp. Tuy nhiên khi mở sổ đỏ ra thì bạn sẽ thấy là bạn chỉ đang có quyền sử dụng đất chứ không phải sở hữu đất. Mọi đất đai đều thuộc quyền sở hữu của nhà nước.

Đây chính là root trong trường hợp này.

> Vì vậy hãy thật cẩn thận khi sử dụng quyền root trên máy tính. Trong trường hợp máy tính, thì chúng ta là chủ sở hữu nên chúng ta có thể enable hay disable root đi. Trên Mac thì mặc định là disable.

## 4.Cách phân quyền

```shell
chmod xyz file/folder
```

Ví dụ:  **chmod 007 duychinh.bin**

Giải thích câu lệnh trên:
- xyz là 3 số nguyên liền nhau (giá trị của ba số này có thể là 0,1,2,3,4,5,6,7).
Với x ứng với quyền phân cho **owner**, y ứng với quyền phân cho **group** và z là cho **everyone**.

**0:** không có quyền gì cả.

**1:** quyền thực thi tập tin.

**2:** quyền write only.

**4:** quyền read only.

Thể hiện dưới dạng nhị phận:

- **0:** 0000
- **1:** 0001
- **2:** 0010
- **4:** 0100

Với 4 số trên ta có thể cộng lại và ra 1 số mới với permission được cộng dồn:

Ví dụ: 7 = 4 + 2 + 1 => tất cả các quyền. Tính toán tương tự với cả tổ hợp khác.
Suy ra với lệnh **chmod 777 file_name**:
- Ta đã gán tất cả quyền cho cả 3 loại user (như liệt kê ở mục 3).

Hình ảnh minh hoạ:

![Branching](http://www.macinstruct.com/images/permissions/permissions1.png)

Trong nhiều trường hợp để có thể thực hiện được lệnh set permission kể trên, ta phải thêm câu lệnh **sudo**.
vào phía trước. Trong các bài tiếp theo sẽ giải thích về ý nghĩa của câu lệnh này.

## 5.Tham khảo

[1] [https://www.guru99.com/file-permissions.html](https://www.guru99.com/file-permissions.html)
