---
title: "SQL Performance Explained"
date: 2020-01-05
tags: ["NOTES"]
label: "[#book]"
---

> The notes of mine after read SQL Performance Explained Ebook.

## Anatomy of an Index

Cơ sở dữ liệu sử dụng 2 loại cấu trúc để lưu trữ index. **B-Tree** và **Doubly Linked List**. Vì vậy cách sử dụng 2 loại cấu trúc này sẽ giải thích cho phần lớn các đặc tính của SQL.

### Doubly Linked List

1. Mỗi một node (node chứa index) sẽ là một node trong 1 node trong 1 **Doubly Linked List**, vì vậy nó sẽ có liên kết tới đến 2 node lân cận (một trước và một sau). Khi ta muốn chèn thêm 1 node mới vào dslk đôi này. Ta sẽ tìm vị trí 2 node cần chèn node mới vào giữa chúng, đơn giản chỉ thay đổi con trỏ của 2 node đó. Vì thế vị trí vật lý của node mới không quan trọng. Lợi ích của việc này là giúp việc chèn thêm dữ liệu không tốn quá nhiều công sức, chỉ thay đổi vài con trỏ.

2. Mỗi **leaf node** được lưu chữ trong 1 block/page. Mỗi block sẽ thườn là 1 vài KB, csdl sẽ cố gắng lưu nhiều node (node chưa index) nhất có thể trong mỗi block/page. Vậy csdl sẽ dùng dsdl đôi để quản lý trong 2 cấp (Dùng trong các node thuộc 1 block/page và dùng giữa các blog với nhau). Hiểu đơn giản như ta chia Việt Nam thành 63 block ứng với 63 tỉnh thành. Mỗi khi ta muốn tìm 1 tỉnh nào đó thì tìm trong sdl đôi của 63 tỉnh. Khi đã tìm thấy tỉnh cần tìm ta muốn tìm đến huyện (các huyện trong tỉnh đó cũng dùng dslk đôi để kết nối). Nhìn hình dưới đây.

![2 level doubly linked list](/../images/leaf-node.png)

### The Search Tree (B-Tree)

1. Dslk đôi giúp thực hiện nhanh các thao tác chèn, xoá node, tuy nhiên vậy còn tìm kiếm thì sao. Nhớ lại cấu trúc dslk thì việc tìm kiếm là tuyến tính, vì vậy chúng ta cần một cấu trúc dữ liệu bổ sung để giúp csdl biết được đối tượng cần tìm đang nằm trong block/page nào 1 cách nhanh chóng. Và cấu trúc dữ liệu được chọn là B-Tree. Nhìn hình dưới đây:

![b-tree](/../images/b-tree-sql.png)

2. Như hình trên. Dslk đôi giúp sắp xếp các node và các block/page. Root và **branch node** giúp đẩy nhanh quá trình tìm kiếm 1 block/page cần thiết.

3. Lý do B-Tree được lựa chọn và sử dụng rộng rãi là vì đặc tính cân bằng của cây. Độ cao của cây là không đổi từ root đến bất kể node lá nào. Tính tăng trưởng chiều cao của cây theo Logarit khi tăng node lá dẫn đến 1 cây bậc 4, 5 có thể chứa hàng triệu node và trong thực tế gần như không có trường hợp nào có độ sâu lên đến 6.


## The Where Clause
