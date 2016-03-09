var express = require('express');
var app = express();


app.get('/', function(request, response) {
    response.setHeader('Content-Type', 'application/json');
    response.send({
        title: 'fizzbuzz',
        subtitle: 'foobar',
        name: 'curry'
    });
});

console.log('---------------------------');
console.log('---------------------------');
console.log('---------------------------');
app.listen(8081);
console.log('App listening on port %d', 8081);
console.log('---------------------------');
console.log('---------------------------');
console.log('---------------------------');
