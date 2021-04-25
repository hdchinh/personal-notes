---
title: "Làm Mini App Cho Vợ P.1"
date: 2020-05-17
---

## Nhu cầu

Chuyện là mình đã lấy vợ được nửa năm, tính ra cũng khá sớm, nhưng âu là cái duyên, duyên đến thì nhận, sớm hay muộn là do nhận mà ra, quan trọng bản thân cảm thấy vui vẻ.

Vợ chồng mình trẻ...và dĩ nhiên cũng nghèo :(, chi tiêu, giá cả tăng phi mã, cái con số lạm phát trên tivi có vẻ không được chính xác, 2 vợ chồng đi làm có cố gắng mà cuối tháng không bỏ ra được đáng bao nhiêu tiền, trong khi còn chưa có con cái, đáng suy ngẫm mà cũng đáng để lo lắng.

Có vấn đề, thì ta tìm cách giải quyết, mình đi đến 2 quyết định:

1. Tìm một công việc khác có thu nhập tốt hơn.
2. Các chi tiêu cần được thống kê lại.

Để có thể thực hiện điều số 2, vợ chồng mình cần chủ động ghi chép lại toàn bộ chi tiêu, mà rồi làm sao để ghi chép?

Mình có tìm hiểu một số ứng dụng thống kê, ghi chép thu chi, nhưng kết quả không tốt, với lý do những ứng dụng đó không match được với nhu cầu. **Hơn nữa điều quan trọng nhất, đó là vợ chồng mình lười, vậy nên để duy trì một thói quen lâu dài, chúng mình cần công việc đó thực sự ĐƠN GIẢN.**

Các ứng dụng mình tìm được quá phức tạp, ngay cả việc mở 1 cái app note lên ghi note text lại thôi, chưa chắc bạn đã làm được ngày này qua ngày khác, huống hồ ghi thu chi.


Vì vậy, mình quyết định làm 1 ứng dụng mini để match đúng nhu cầu mình đang có, và nó phải đơn giản, đơn giản đến mức mình (1 người lười) cũng có thể duy trì lâu dài.

## Dự định

Với dự định như trên, mình quyết định làm 1 **Chat Bot** đơn giản, để mỗi lần ghi thu chi mình có thẻ mở 1 app nhắn tin nào đó lên gõ và enter là xong. Tiếp đó mình cần 1 **web app** cũng đơn giản không kém, chỉ cần có chức năng đăng nhập, xem thu chi trong ngày, trong tháng, trong năm, xem đồ thị so sánh giữa các ngày trong tuần, xem đồ thị so sánh giữa các tuần trong tháng, và có thể trong tương lai là so sánh các ngày trong năm, và có chức năng gửi report qua email. Vậy là ổn và match với nhu cầu tiết kiệm của vợ chồng mình.

Với số tính năng trên mình đã lựa chọn như sau:

1. **Chat Bot**: Sử dụng nền tảng của facebook messenger (lý do: nổi tiếng, bản thân mình và vợ cũng hay xài).

2. **Web App**: Backend (Ruby On Rails, mình có 1 side project nên giờ chỉ viết thêm module cho phần chức năng cần có của app thu chi chứ không cần tạo project từ đầu - Triển khai trên Heroku), Frontend (Reactjs - Triển khai trên Now.sh).

Flow như sau:

1. Mình gửi tin nhắn đến facebook chatbot.
2. Tin nhắn đó được gửi tới server backend. Backend phân tích format của tin nhắn và lưu lại thông tin nếu dữ liệu hợp lệ.
3. Mình vào web Frontend để monitor quá trình chi tiêu.

## Tổng kết

Khi mình viết bài viết này, thì ứng dụng nhỏ này đã được triển khai và vợ chồng mình đã có 1 tuần sử dụng, chúng mình khá ưng ý, hi vọng có thể duy trì thói quen này lâu dài.

Qua đây mình sẽ viết quá trình làm mini app này, từ khi làm tới khi triển khai và sau đó là cố gắng học hỏi để improve tổ chức project tốt hơn (mình chưa có nhiều kinh nghiệm Frontend, nên đây cũng là cơ hội để đọc những tài liệu hay ho về Frontend).
