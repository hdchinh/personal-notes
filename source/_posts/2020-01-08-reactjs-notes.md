---
title: "ReactJS Short Note"
date: 2020-01-08
tags: ["NOTES"]
label: "#note"
---

> This is a short note from ReactJS docs.

## Main Concepts

### 1.JSX

JSX là **syntax extension to JavaScript**

Lý do cần sự xuất hiện của JSX là để React nhúng logic vào giao diện.

Nhưng biểu thức logic vào JSX thông qua cặp ngoặc **{}**:

```jsx
const name = "Meo";
const element = <b>{name}</b>
```

Chúng ta cũng có thể nhúng JSX vào một **if** hay **for** trong javascript:

```jsx
function getGreeting(user) {
  if (user) {
    return <h1>Hello, {formatName(user)}!</h1>;
  }

  return <h1>Hello, Stranger.</h1>;
}
```

Nhứng biểu thức vào Attributes của một đối tượng:

```jsx
const element = <img src={user.avatarUrl}></img>;
```

Note: Dùng "" cho chuỗi, dùng {} cho biểu thức logic, không dùng 2 thứ cùng lúc.

JSX diễn tả một đối tượng:

Khi babel biên dịch, đối tượng trên sẽ được call trong **React.createElement()**

```jsx
const element = (
  <h1 className="greeting">
    Hello, world!
  </h1>
);
```

Sau biên dịch sẽ thành:

```jsx
const element = {
  type: 'h1',
  props: {
    className: 'greeting',
    children: 'Hello, world!'
  }
};
```

### 2.Render Element

React dùng các đối tượng này để xây dựng cây DOM.

React elements là immutable. Một khi bạn tạo một element, bạn không thể thay đó thuộc tính hoặc children của nó. Một element React giống như một đoạn trong 1 cuốn phim: Nó chỉ đại diện cho UI trong 1 thời điểm.

Do vậy, cách duy nhất để cập nhật giao diện là tạo ra một phần tử mới thay thế cho phần tử cũ. Và cách duy nhất để tạo ra một phần tử React là dùng **ReactDOM.render()**

### 3.Component và Props

**Function Component**:

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```

Chỉ chấp nhận 1 params props.

**ES6 Class**:

```jsx
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```

Khi sử dụng Class sẽ có một số chức năng được bổ sung.

>  React elements: là  thứ được biên dịch qua babel ở mục 2

React element có thể đại diện cho DOM tag hoặc user-defined components

```jsx
const element = <div />;

const element = <Welcome name="Sara" />;
```

React khi gặp các element đại diện cho một user-defined componts, nó sẽ pass jsx attributes vào component đó dưới dạng **MỘT OBJECT DUY NHẤT**, đó là props.

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}

const element = <Welcome name="Sara" />;
ReactDOM.render(
  element,
  document.getElementById('root')
);
```

Trong ví dụ trên, object duy nhất là: **props = {name: "Sara"}**

1. We call ReactDOM.render() with the `<Welcome name="Sara" />` element.
2. React calls the Welcome component with {name: 'Sara'} as the props.
3. Our Welcome component returns a `<h1>Hello, Sara</h1>` element as the result.
4. React DOM efficiently updates the DOM to match `<h1>Hello, Sara</h1>`.

> Luôn tạo một component với chữ cái đầu viết hoa, react dùng đấy để nhận diện chữ DOM tag và user-defined components

### 4.State và vòng đời

Nơi duy nhất ta có thể set state là trong constructor. Ở các khu vực khác, phải call hàm setState để thay đổi giá trị state.

Cập nhật state là bất đồng bộ. Để khắc phục, setState nhận tham số đầu tiên là state cũ.

```jsx
// Correct
this.setState((state, props) => ({
  counter: state.counter + props.increment
}));
```

```jsx
constructor(props) {
  super(props);

  this.state = {
    name: 'Chinh',
    age: 25
  }
}
```

Khi gọi:

```jsx
this.setState({
  name: 'Duy'
})
```

name trong state sẽ được replace và thay mới, còn age thì giữ nguyên => gọi là merge vậy thôi

## Advandced Guide

## React Hooks

## Original Link

[1] [https://reactjs.org/docs](https://reactjs.org/docs)
