fetch('http://localhost:4000/cats.json')
  .then((response) => {
    console.log(response);
  })
  .then((myJson) => {
    console.log(myJson);
  });
