---
title: "Callback, Promise, Async Await"
date: 2020-01-09
tags: ["NOTES"]
label: "#note"
---

## 1. Event Loop

Javascript chạy đơn luồng, tương tự như ruby, nhưng khác một điều, môi trường làm việc của javascript đa phần là trình duyệt, nếu mọi thứ đều chạy tuần tự đơn luồng liệu có ổn không?

Ví dụ:

```javascript
API.get("/cats")

API.get("/dogs")
```

Giả dụ đoạn code lấy về dữ liệu dogs bên trên gặp lỗi hoặc tốn rất nhiều thời gian để thực hiện, khi đó giao diện (trên trình duyệt) của người dùng sẽ treo hoàn toàn nếu javascript không có giải pháp cho sự đơn luồng và chạy tuần tự?

Cách giải quyết là nó đơn luồng và chạy không tuần tự, hay còn gọi là chạy bất đồng bộ:

Vậy javascript và ruby cùng là đơn luồng, nhưng javascript chạy bất đồng bộ còn ruby thì chạy đồng bộ tuần tự.

Video số [6] dưới mục tham khảo đã giải thích rất hay về event loop và không có lý do gì chúng ta đi ghi lại 1 thứ đã có người làm quá tốt. Một vài lưu ý mình lượm lặt nên note lại:

1. Event Loop có một nhiệm vụ duy nhất - giám sát **Call Stack** và **Callback Queue**. Nếu Call Stack trống, nó sẽ lấy sự kiện đầu tiên từ queue và đẩy vào Call Stack

2.Những Web API này là gì? Chúng là những thread mà bạn không thể truy cập được, chỉ có thể gọi để xài mà thôi. Chúng là những nhân tố trong trình duyệt mà thực sự có thể chạy đồng thời (concurrency). Vậy thì event loop là gì:

3. ES6 giới thiệu khái niệm về job queue được sử dụng bởi Promises trong JavaScript. Sự khác biệt giữa message queue và job queue là job queue có mức ưu tiên cao hơn message queue, có nghĩa là các promise job bên trong job queue sẽ được thực thi trước các callback bên trong message queue.


## 2. Callback

Trong js, function cũng là object.

Khi chúng ta truyền function A và function B dưới dạng tham số của B, lúc này A được gọi là Callback function.

```javascript
function A() {
  console.log("Pass me in B, but I don't know why we need do that");
}

function B(callback) {
  callback();
}

B(A);
```

Khi chúng ta truyền function không tên vào B thay vì truyền 1 function có tên là A, lúc này function đó gọi là anonymous function, trường hợp này chúng ta làm rất nhiều, tiêu biểu là các event jquery chúng vẫn dùng hay hàm `setTimeout` build-in trong javascript cũng là một ví dụ tiêu biểu, nó nhận vào 2 tham số: một function và 1 khoảng thời gian dạng milisecond.

```javascript
function B(callback) {
  console.log("Do something before call callback");
  callback();
  console.log("Do something after call callback");
}

B(function() {
  console.log("Callback runing...");
});

// Output will be:

// Do something before call callback
// Callback runing...
// Do something after call callback
```

Tại sao cần dùng callback?

Vì bản chất của ngôn ngữ javascript là bất đồng bộ, làm gì làm luôn, mày làm trễ/chậm thì kệ mày, t** éo thích tuần tự.

```javascript
// Copy from: https://www.freecodecamp.org/news/what-is-a-callback-function-in-javascript/
function serverRequest(query, callback){
  setTimeout(function(){
    var response = query + "full!";
    callback(response);
  },5000);
}

function getResults(results){
  console.log("Response from the server: " + results);
}

serverRequest("The glass is half ", getResults);

// Result in console after 5 second delay:
// Response from the server: The glass is half full!
```

Trong ví dụ trên, chúng ta giả lập 1 request tới server, và request này tốn 5s, sau khi request này có kết quả thì 1 function khác ở đây mới chạy, chính là function `getResults`, vì vậy truyền `getResults` dưới dạng callback function vào `serverRequest` rồi "sau khi nhận được response từ server" ta truyền dữ liệu đó cho callback function để nó làm công việc mà nó cần làm.

Một ví dụ khác:

```javascript
// Copy from: https://codeburst.io/javascript-what-the-heck-is-a-callback-aba4da2deced
T.get('search/tweets', params, function(err, data, response) {
  if(!err){
    // This is where the magic will happen
  } else {
    console.log(err);
  }
})
```

Trong ví dụ trên, callback function sẽ chạy sau khi mà cái hàm `T.get` chạy xong, các tham số của callback function chính là các giá trị `T.get` trả về.

## 3. Promise

```javascript
let p = new Promise((resolve, reject) => {
  let a = 1

  response = {
    success: true,
    data: {
      name: 'Chinh',
      age: 25
    }
  }

  if (a == 1) {
    resolve(response);
  } else {
    reject('Fail');
  }
});

p.then((data) => {
  if (data.success) {
    console.log('This is data: ', data.data);
  } else {
    console.log('Something went wrong!');
  }
}).catch((err) => {
  console.log('The error is: ', err);
});
```

Ví dụ 2 về **Promise.all**

```javascript
let cats = new Promise((resolve, reject) => {
  resolve("all cats");
});

let dogs = new Promise((resolve, reject) => {
  resolve("all dogs");
});

Promise.all([
  cats,
  dogs
]).then((data) => {
  console.log(data);
});

// Output will be:
// ["all cats", "all dogs"]
```

## 4. Async Await

Clear code cho promise, được bổ sung trong ES7

```javascript
// Copy from: https://www.youtube.com/watch?v=V_Kr9OSfDeU
function makeRequest(location) {
  return new Promise((resolve, reject) => {
    if (location === 'Google') {
      resolve('Google say hi');
    } else {
      reject('You can only talk to google');
    }
  })
}

function processRequest(response) {
  return new Promise((resolve, reject) => {
    console.log('Processing response');
    resolve(`Extra information: ${response}`)
  });
}

// Promise hell
makeRequest('Google').then(data => {
  processRequest(data).then(extraData => {
    console.log('Final data: ', extraData)
  })
}).catch((err) => {
  console.log('err: ', err);
});

// Update to fix Promise hell
makeRequest('Google')
  .then(data => {
    return processRequest(data)
  })
  .then(extraData => {
    console.log('Final data: ', extraData)
  })
  .catch((err) => {
    console.log('err: ', err);
  });
```

Update thành dùng **async await**

```javascript
async function doWork() {
  try {
    const response = await makeRequest('Google');
    const processedResponse = await processRequest(response);
    // Do anything with processedResponse
  } catch (err) {
    console.log('err: ', err);
  }
}
```

## 5. References

[1][https://viblo.asia/p/javascript-callback-function-PdbGnozAeyA](https://viblo.asia/p/javascript-callback-function-PdbGnozAeyA)
[2][https://kipalog.com/posts/Promise-la-khi-gi-](https://kipalog.com/posts/Promise-la-khi-gi-)
[3][https://www.freecodecamp.org/news/what-is-a-callback-function-in-javascript/](https://www.freecodecamp.org/news/what-is-a-callback-function-in-javascript/)
[4][https://codeburst.io/javascript-what-the-heck-is-a-callback-aba4da2deced](https://codeburst.io/javascript-what-the-heck-is-a-callback-aba4da2deced)
[5][https://viblo.asia/p/hieu-ve-asynchronous-javascript-RQqKLARmZ7z](https://viblo.asia/p/hieu-ve-asynchronous-javascript-RQqKLARmZ7z)
[6][https://www.youtube.com/watch?v=8aGhZQkoFbQ](https://www.youtube.com/watch?v=8aGhZQkoFbQ)
[7][https://www.youtube.com/watch?v=DHvZLI7Db8E](https://www.youtube.com/watch?v=DHvZLI7Db8E)
[8][https://www.youtube.com/watch?v=V_Kr9OSfDeU](https://www.youtube.com/watch?v=V_Kr9OSfDeU)
