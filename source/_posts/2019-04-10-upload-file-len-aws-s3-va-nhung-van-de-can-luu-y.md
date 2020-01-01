---
title: "Upload Với S3 Trong Rails"
date: 2019-04-10
draft: false
tags: ["aws", "rails", "til"]
categories: ["rails notes"]
mytag: "#TIL"
---

Ghi chú này được tham khảo từ bài viết [Lưu trữ file trên Amazon S3](https://viblo.asia/p/ror-luu-tru-file-tren-amazon-s3-BMvRpNXEzwY#_cau-hinh-connect-toi-dich-vu-s3-trong-ung-dung-rails-3) của tác giả **@duyth1993** trên website **viblo.com**.

Bài toán: Hiện tại tôi đang cần tìm một dịch vụ lưu trữ file, trước giờ tôi không sử dụng vì chưa có nhu cầu. Tìm kiếm một lúc thì tôi quyết định sử dụng S3 vì sẵn cũng đang còn tài khoản free của của AWS, tham khảo bài viết bên trên một số lưu ý khi sử dụng này mà tôi rút ra như sau:

1. Bài viết trên của tác giả viết rất chi tiết, tuy nhiên hướng dẫn đó là trên rails 4 và cần chú ý thay đổi một số config để phù hợp với rails 5 mà tôi đang sử dụng. Đó là về việc sử dụng **credentials** thay thế cho **secret**, thông tin đầy hơn có thể tham khảo tại bài viết [Rails và bảo mật thông tin quan trọng](http://hdchinh.com/2019/02/22/2019-02-22-xu-ly-thong-tin-quan-trong-trong-rails/).

2. Có 4 thông tin quan trọng để cấu hình đến S3 đó là: **access_key_id**, **secret_access_key**, **region** và **bucket_name**.

3. Một số config để connect tới server S3 là do thư viện **aws-sdk-rails** quy định vì vậy đơn giản là làm theo và không thắc mắc tại sao.

4. Cần chú ý bước config cho file trước khi upload với các thông tin như: **content_type**(định dạng file, việc sử dụng định dạng file dạng không tương thích với ảnh bạn upload lên dẫn để việc không thể hiển thị view bức ảnh đó.), **acl**(access control list: quy định về việc ai có thể access khi có url của file) và **server_side_encryption**(lựa chọn này để mã hóa file bạn tải lên, đi kèm đó là giảm hiệu năng vì thêm 1 bước cần xử lý.)

Source demo xem tại [đây](https://github.com/hdchinh/S3_with_rails_5.2)
