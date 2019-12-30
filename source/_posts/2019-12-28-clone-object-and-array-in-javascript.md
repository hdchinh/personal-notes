---
title: Clone Object And Array In JS
date: 2019-12-28
tags: ["JS"]
---

> Recommend from some developers who have more exp than me: 'Should use LoDash library'

## Why do we have to clone?

In fact, when we working on our projects, many times we need to get data from an object or an array and use it for some features what we want. In some cases, we need to change data from original object, but some other cases we need a version copy because we must keep original data not change.

So, in this case, what do you do? Do you ever think we can do it easy by some code below:

```javascript
let obj = {name: 'Chinh', age: 25}

let copy_obj = obj
```

And we now can free to change **copy_obj** without fear of changing **obj**?

So sad, the above way cannot work right. Why? why it is wrong? Everything same like fine, what's problem we have?

> The problem at here is **Objects(array is an object) are reference types**.

What does that mean?

That mean: Reference types doesn't hold any data, it's only contains a pointer to the value of object in memory.

When you use **=**, **copy_obj** will contains a pointer to the value of **obj**. So, if you change anything in **copy_obj** or **obj**, the other variable will change too.

## Clone Object and Array
> We have many ways to clone an object, but there are three main ways need to know.

1. Use spread syntax.

```javascript
let obj = {name: 'Chinh', age: 25}

let copy_obj = {...obj}
```

2. Use Object.assign

```javascript
let obj = {name: 'Chinh', age: 25}

let copy_obj = Object.assign({}, obj)
```

3. Use JSON

```javascript
let obj = {name: 'Chinh', age: 25}

let copy_obj = JSON.parse(JSON.stringify(obj))
```

> We know in javascript, array is also an object, thus all approach that we use for object above can apply for array too.

## Deep Clone And Shallow Clone

> Deep Clone is mean copy everything to another memory.

> Shallow Clone is mean it's only copy first level of original object to another memory.From second level it's references to original object.

> Use Object.asign or JSON are deep clone. In the most cases, using Object.assign show a lot faster than JSON.

> Use spread is shallow clone.

Take a look to the sample code below to know why use spread is shallow clone:

```javascript
obj = {
  name: 'Chinh',
  age: 25
  location: {
    city: 'Saigon'
  }
}

clone_obj = {...obj}

clone_obj.name = "Duy Chinh"

clone_obj.location.city = "Nam Dinh"

console.log(obj)
```

The result will be:

```javascript
{
  name: "Chinh",
  age: 25,
  location: {
    city: "Nam Dinh"
  }
}
```

City in original object has changed

## References

[1][https://www.samanthaming.com/tidbits/50-how-to-deep-clone-an-array](https://www.samanthaming.com/tidbits/50-how-to-deep-clone-an-array)

[2][https://www.samanthaming.com/tidbits/70-3-ways-to-clone-objects](https://www.samanthaming.com/tidbits/70-3-ways-to-clone-objects)
