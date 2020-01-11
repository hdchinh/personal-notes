var myObj = {

  name: 'Chinh',
  age: 25,

  funcFirst: function () {
  },

  funcSecond: function () {
  },

  getAsyncData: function (callbackNe) {
    callbackNe();
  },

  render: function () {
      var that = this;

      this.getAsyncData(function () {
          that.funcFirst();
          that.funcSecond();
      });
  }
};


myObj.render();

function bike() {
  console.log(this.name);
}

let name = "Ninja";

var obj1 = { name: "Pulsar", bike: bike };
var obj2 = { name: "Gixxer", bike: bike };


console.log('bike', this)
bike();          // "Ninja"
obj1.bike();      // "Pulsar"
obj2.bike();
