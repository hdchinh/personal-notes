---
title: "Lưu Trữ Thông Tin Bảo Mật Trong Rails?"
date: 2019-02-22
draft: false
tags: ["secure", "rails"]
categories: ["rails notes"]
mytag: "Rails"
mytrend: "COOL"
---

## 1. Khái quát

Bài toán này đơn giản hiểu như sau: Một project bất kỳ sẽ luôn có những thông tin cấu hình vô cùng quan trọng, bắt buộc phải luôn giữ chúng private, còn làm cách nào để giữ chúng private trong rails?
Câu trả lời là tuỳ vào mỗi phiên bản rails, sẽ có (có thể có) những cách khác nhau để xử lý vấn đề này. Hãy đi đến các dấu mốc cụ thể dưới đây.

## 2. Rails 4.1

Phiên bản rails này sử dụng một file có tên **secrets.yml**, đây là file sẽ lưu toàn bộ các thông tin nhạy cảm chúng ta đã nói ở trên.
Với thiết kế như này ta có hai lựa chọn cho ứng dụng của mình:
1. Đem hết thông tin nhạy cảm dưới đạng text bỏ vào file này, tuy nhiên file này phải được bỏ vào trong danh mục của **gitignore** để đảm bảo thông tin trong đó không bị bạn vô tình hay hữu ý commit đi đâu đó.

2. Thông tin nhạy cảm lưu trong file này thay vì được lưu dưới dạng text thì sẽ được lưu trong máy của bạn dứoi dạng **biến môi trường** và trong file **secrets.yml** chỉ sử dụng phương thức **ENV** mà rails cung cấp để gọi lại các thông tin đó lên, với lựa chọn này bạn có thể commit file này thoải mái, ở các máy tính đồng nghiệp, để có thể sử dụng được những config này thì buộc họ phải thiết lập biến môi trường trên máy tính của họ cho phù hợp.

Nhược điểm: dù sử dụng cách nào, thì để ứng dụng hoạt động được thì vẫn phải truyền giá trị các thông tin nhạy cảm này từ máy của bạn lên một con vps khi triển khai chẳng hạn, không còn cách nào khác. Có thể bạn phải copy từng dòng thông tin nhạy cảm rồi paste qua remote shell để thiết lập (với những dự án lớn có rất nhiều thông tin quan trọng thì đây là 1 công việc vất vả tiềm tàng nguy cơ sai sót).

Note: Thay vì sử dụng file **secrets.yml**, ta có thể sử dụng một file khác như **application.yml**, mục đích và chức năng của chúng là tương đương.

## 3. Rails 5.1

Sang đến phiên bản rails 5.1, một thay đổi lớn đã tới. Thay vì lưu thông tin dạng text hoặc triệu hồi thông qua biến môi trường, rails khi này cung cấp khả năng mã hoá cho các thông tin nhạy cảm này.
Cách chúng hoạt động như sau:

Một file tên **secrets.yml.key** sẽ chứa giá trị của một biến tên **RAILS_MASTER_KEY**, biến này có giá trị là một chuỗi, có chức năng được sử dụng để mã hoá và giải mã các thông tin quan trọng.

Nội dung thông tin **sau** mã hoá sẽ được lưu tại file **secrets.yml.enc**

Vậy còn file **secrets.yml** trong rails 4 giờ còn không? Câu trả lời là bạn vẫn có thể sử dụng file này, tuy nhiên trên cùng một môi trường, nếu có cả file **secrets.yml** và **secrets.yml.enc** thì hai file này sẽ được merge.

Để có thể sử dụng tính năng encypt này của rails 5.1 ta setup như sau:

```ruby
rails secrets:setup
```
Sau câu lệnh này hai file **secrets.yml.key** và **secrets.yml.enc** sẽ được tạo ra. Để thêm xoá sửa nội dung trong **secrets.yml.enc** ta sử dụng lệnh sau:

```ruby
rails secrets:edit
```

Câu lệnh này sẽ mở nội dung file **secrets.yml.enc** dưới dạng đã giải mã. Bạn có thể thoải mái thêm xoá, sửa các thông tin nhạy cảm, sau đó khi bạn save lại và tắt editor thì file **secrets.yml.enc** sẽ tự động được cập nhập phần mã hoá mới nhất khi có thêm thông tin.

Tôi thích dùng **vim** để chỉnh sửa, và tôi không muốn set mặc định editor nên tôi sử dụng câu lệnh sau: **EDITOR=vi rails secrets:edit**.

Ưu điểm:

1. Thay vì phải quản lý nhiều biến môi trường, giờ đây mọi thứ đều nằm trong một file.

2. Việc có thể commit **secrets.yml.enc** giúp chúng ta nắm được lịch sử thay đổi của file này.

Note: Một điểm quan trọng bạn cần lưu ý, đó là tới khi viết bài viết này thì tôi vẫn chưa thấy rails sẽ giải mã thông tin mã hoá trong file **secrets.yml.enc**, chúng ta buộc phải làm thủ công để nhắc rails làm điều đó bằng cách thêm vào config file của bạn **config.read_encrypted_secrets = true**. Với câu lệnh setup bên trên, dòng config trên đã được add vào file config của production. Nếu bạn muốn sử dụng tính năng này cho môi trường development thì hãy thêm dòng config này vào file **config/environments/development.rb**.

## 3. Rails 5.2

Ý tưởng trong rails 5.2 không thay đổi nhiều so với rails 5.1. Nhưng thay vì lưu key để encrypt/decrypt trong file secrets.yml.key giờ nó được lưu trong file **master.key** (tuy nhiên nếu không sử dụng file thì cả rails 5.2 và 5.1 đều có thể gọi biến môi trường RAILS_MASTER_KEY để sử dụng).

File lưu thông tin đã được mã hoá cũng được thay đổi từ secrets.yml.enc thành **credentials.yml.enc**.  Đó là những điểm khác biệt duy nhất.

Để chỉnh sửa thông tin trong file mã hoá ta sử dụng lệnh:

```ruby
EDITOR=vi rails credentials:edit
```
Không cần dùng lệnh setup như trên, vì trong rails 5.2, hai file key và mã hoá được sinh ra cùng project.

Ta có thể truy xuất giá trị được giải mã trong file **credentials.yml.enc** như sau:

```ruby
Rails.application.credentials.ten_bien_trong_credentials
```

Làm gì khi bạn muốn thay thế **master.key**?

1. **rails credentials:show** dùng lệnh này để hiển thị thông tin dạng giải mã ra editor, copy chúng.

2. Xoá hai file **master.key** và **credentials.yml.enc** đi.

3. **EDITOR=vim rails credentials:edit** với lệnh sau bạn sẽ generate lại hai file mới. Việc cần làm bây giờ là paste thông tin ở bước 1 vào editor khi này rồi save lại.

## 4. secret_key_base

Nếu làm theo hướng dẫn bên trên, ta sẽ thu được một file mã hoá ví dụ: **credentials.yml.enc** có chứa nội dung ngay cả khi ta mới vừa khởi tạo project. Điều gì đã xảy ra? Tôi còn chưa kịp edit thì nó lấy thông tin gì mà mã hoá ra nội dung đó vậy? Câu trả lời là một thứ được tạo kèm project của bạn có tên là **secret_key_base** sẽ là thứ đầu tiên được tự động lưu mã hoá vào file **credentials.yml.enc**.

Sao lại phức tạp như vậy? nó với **RAILS_MASTER_KEY** ở trên có quan hệ gì không? Câu trả lời là không? **secret_key_base** được rails sinh ra khi tạo project, nó đảm bảo rằng không thể có hai ứng dụng rails có chung một **secet_key_base**, cái key sẽ được sử dụng để đảo bảo thứ đánh dấu tính duy nhất của một project và nó còn được dùng làm nhiều việc hay ho khác tôi sẽ trình bày trong các bài viết sắp tới.

Để tạo ra một secret_key_base bạn có thể sử dụng lệnh sau:

```ruby
rails secret
```
