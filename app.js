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

var cluster = require('cluster');
cluster.on('c', function(x){console.log(x)});
if (cluster.isMaster) {
  console.log("im master");
  cluster.fork();
  cluster.emit('c', 'greeting from parent :)')
} else {
  console.log("im slave. bye bye");
  cluster.emit('c','greeting from child :o')
  process.exit(0);
}


return; // exit the scope. atExitCB