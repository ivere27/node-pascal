'ust strict'

var num = 42;
var foo = 'foo';
global.bar = function(x) {
  return `${foo} bar ${x}`;
}
var baz = function(x) {
  console.log(`baz() = ${foo} ${x}`);
}

toby.on('test', function(x){
  console.log(`toby.on(test) = ${x}`);
});

var result = toby.hostCall('dory', {num, foo});
console.log(`toby.hostCall() = ${result}`);


//setInterval(function(){},1000); // dummy event


return; // exit the scope. atExitCB