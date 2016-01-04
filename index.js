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


app.listen(process.env.PORT || 3000);
console.log('App listening on port %d', process.env.PORT || 3000);


