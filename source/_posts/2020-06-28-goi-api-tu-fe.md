---
title: "Gọi API Tại Frontend"
date: 2020-06-28
label: "#note"
---

## 1. Fetch

Fetch là một module được tích hợp sẵn trong các trình duyệt, điều đó có nghĩa là không phải tất cả các trình duyệt cũ đều có thể sử dụng fetch.

Ưu điểm là không cần cài thêm package cho phần xử lý API. Nhược điểm là chỉ dùng cho ứng dụng chạy với trình duyệt.

Đối tượng được trả về là dạng Stream, đồng nghĩa với việc phải convert khi gửi data lẫn khi nhận data.

### 1.1 Fetch với async await

```
async function getCats() {
  try {
    const url = "http://localhost:4000/api/v1/cats";
    const response = await fetch(url);
    const responseJSON = await response.json();

    return responseJSON.data;
  } catch (err) {
    return [];
  }
}

// Set data to state
getCats().then((cats) => {
  this.setState({ cats });
});
```

### 1.2 Fetch với Promise

```javascript
const url = "http://localhost:4000/api/v1/cats";
const _this = this;

fetch(url)
.then(
  function(response) {
    // .json() return a promise
    response.json().then(data => {
      _this.setState({
        cats: data.data
      });
    })
  }
)
.catch(err => {
  console.log('Error:', err)
});
```

###  1.3 Các ví dụ khác

```javascript
// Copy from: http://vuilaptrinh.com/2018-10-01-huong-dan-gioi-thieu-fetch-javascript
function status(response) {
  if (response.status >= 200 && response.status < 300) {
    return Promise.resolve(response)
  } else {
    return Promise.reject(new Error(response.statusText))
  }
}
function json(response) {
  return response.json()
}

fetch('')
  .then(status)
  .then(json)
  .then(data => {
    console.log('Request succeeded with JSON response', data);
  })
  .catch(function(error) {
    console.log('Request failed', error);
  });


fetch(url, {
  method: 'POST',
  headers: {
    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
  },
  body: 'foo=bar&lorem=ipsum'
})
.then(json)
.then(data => {
  console.log('Request succeeded with JSON response', data);
})
.catch(error => {
  console.log('Request failed', error);
});

// Post json object
var data = {username: 'example'};

fetch(url, {
  method: 'POST',
  body: JSON.stringify(data),
  headers:{
    'Content-Type': 'application/json'
  }
})
.then(res => res.json())
.then(response => console.log('Success:', JSON.stringify(response)))
.catch(error => console.error('Error:', error))
```

## 2. Axios

```javascript
axios.get(`http://localhost:4000/api/v1/cats`)
  .then(res => {
    const persons = res.data;
    this.setState({ cats });
  })

const user = {
  name: this.state.name
};

axios.post(`http://localhost:4000/api/v1/cats`, { user })
  .then(res => {
    console.log(res);
    console.log(res.data);
  })
```

## 3. References

[1][http://vuilaptrinh.com/2018-10-01-huong-dan-gioi-thieu-fetch-javascript/](http://vuilaptrinh.com/2018-10-01-huong-dan-gioi-thieu-fetch-javascript/)
[2][https://alligator.io/react/axios-react/](https://alligator.io/react/axios-react/)
