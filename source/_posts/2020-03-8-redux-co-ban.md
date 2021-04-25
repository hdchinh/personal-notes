---
title: "Redux Notes"
date: 2020-01-09
tags: ["NOTES"]
label: "#note"
---

Source from:

[1][https://www.youtube.com/watch?v=HOrA-uzZpw8](https://www.youtube.com/watch?v=HOrA-uzZpw8)
[2][https://github.com/paulnguyen-mn/redux-pure-js/blob/master/main.js](https://github.com/paulnguyen-mn/redux-pure-js/blob/master/main.js)

```javascript
// Copy from: https://github.com/paulnguyen-mn/redux-pure-js/blob/master/main.js
console.log(window.Redux)

const { createStore } = window.Redux;

// SETUP REDUX STORE
// state
// reducer
// store
const initialState = JSON.parse(localStorage.getItem('hobby_list')) || [];

const hobbyReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'ADD_HOBBY': {
      const newList = [...state];
      newList.push(action.payload);

      return newList;
    }
    default:
      return state;
  }
}

const store = createStore(hobbyReducer);

// -----------------

// RENDER REDUX HOBBY LIST
const renderHobbyList = (hobbyList) => {
  if (!Array.isArray(hobbyList) || hobbyList.length === 0) return;

  const ulElement = document.querySelector('#hobbyListId');
  if (!ulElement) return;

  // reset previous content of ul
  ulElement.innerHTML = '';

  for (const hobby of hobbyList) {
    const liElement = document.createElement('li');
    liElement.textContent = hobby;

    ulElement.appendChild(liElement);
  }
}


// RENDER INITIAL HOBBY LIST
const initialHobbyList = store.getState();
console.log(initialHobbyList);
renderHobbyList(initialHobbyList);


// HANDLE FORM SUBMIT
const hobbyFormElement = document.querySelector('#hobbyFormId');
if (hobbyFormElement) {
  const handleFormSubmit = (e) => {
    // prevent browser from reloading
    e.preventDefault();

    const hobbyTextElement = hobbyFormElement.querySelector('#hobbyTextId');
    if (!hobbyTextElement) return;

    console.log('SUBMIT', hobbyTextElement.value);
    const action = {
      type: 'ADD_HOBBY',
      payload: hobbyTextElement.value
    };
    store.dispatch(action);

    // reset form
    hobbyFormElement.reset();
  };

  hobbyFormElement.addEventListener('submit', handleFormSubmit);
}

store.subscribe(() => {
  console.log('STATE UPDATE: ', store.getState());
  const newHobbyList = store.getState();
  renderHobbyList(newHobbyList);

  localStorage.setItem('hobby_list', JSON.stringify(newHobbyList));
});
```
