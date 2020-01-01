---
title: "Lệnh Open Trên macOS"
date: 2018-01-23
draft: false
tags: ["UNIX"]
label: "[@til]"
categories: ["OS"]

---

## 1.Folders

Ngoài việc có thể mở được thư mục bạn đang làm việc, nó có thể mở được các thư mục khác trong máy tính của bạn chỉ bằng việc bạn cung cấp đường dẫn phía sau câu lệnh open thay vì dấu chấm như chúng ta đã làm ở trên. Bạn cũng có thể mở các thư mục ẩn hay mở nhiều thư mục cùng một lúc.
Dưới đây là một vài ví dụ cho những gì chúng ta đã thảo luận ở trên:

**open ~/**

**open ~/etc ~/desktop ~/documents**

## 2.File

Open cũng có thể mở tập tin, lại tiếp tục suy nghĩ đơn giản, chúng ta có thể thấy câu lệnh này giống như một cú click chuột double vào file hay folder thì đều có chức năng mở nó lên. Ví dụ:

**open ~/desktop/meo.rb**

Nó sẽ mở file meo.rb. Bạn cũng có thể sử dụng điều này với nhiều tệp.

**open ~/desktop/meo.rb ~/desktop/meo.jpg**

## 3.Applications

Giả sử tôi có file meo.rb, bây giờ file đó sẽ được mở mặc định bởi phần mềm Xcode trong máy của tôi. Khi đó, tôi có thể override lại phần mềm mặc định để mở file này bằng câu lệnh sau:

**open -a Sublime ~/desktop/meo.rb**

## 4.URLs

Open cũng có thể mở các đường dẫn URL với cú pháp đơn giản như sau:

**open https://google.com.vn**

Với câu lệnh này thì đường dẫn bạn cung cấp sẽ được mở bằng trình duyệt mặc định. Bạn cũng có thể sử dụng trình duyệt khác làm trình duyệt mặc định bằng tuỳ chọn –a như sau:

**open -a Firefox https://google.com.vn**
