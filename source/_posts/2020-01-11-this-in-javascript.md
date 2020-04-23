---
title: "The THIS Keyword In Javascript"
date: 2020-01-10
tags: ["JS"]
# label: "note"
---

I don't remember I write the first line of JS code how long before from now. It seems like happen every a long time ago, Until now, I still do not know what exactly is **this** in JS. Too bad, but today I will try to understand it again.

## What is THIS?

**this** is an object in Javascript and object in Javascript like a hash in other language programming.

In a blank file js, if you run one line code blow:

```javascript
console.log(this);
```

So, what is appear after run? The output will not is an error, just like blow:

```javascript
{}
```

So, yes, **this** always exist in Javascript code. I used to believe **this** only exist in an object or in a function, but it's not true.

> The JavaScript this keyword refers to the object it belongs to. So that is why always exist an this in Javascript.

## THIS in Context

**This** has different values depending on where it is used:

1. In a **method**, this refers to the **owner object**.

2. **Alone**, this refers to the **global object**.

3. In a **function**, this refers to the **global object**.

4. In a **function, in strict mode**, this is **undefined**.

5. In **an event**, this refers to **the element that received the event**.

6. Methods like call(), and apply() can refer this to any object.

## Reference

[1][https://www.w3schools.com/js/js_this.asp](https://www.w3schools.com/js/js_this.asp)

[2][https://developer.mozilla.org/en-US/docs/Glossary/Global_object](https://developer.mozilla.org/en-US/docs/Glossary/Global_object)

[3][https://www.smashingmagazine.com/2014/01/understanding-javascript-function-prototype-bind/](https://www.smashingmagazine.com/2014/01/understanding-javascript-function-prototype-bind/)
