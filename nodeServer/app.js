var express = require('express');
var app = express();

var bodyParser = require('body-parser');
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: false })); // support encoded bodies


var device = "sds";
var buffers = [];

app.post ('/post', function (req, res) {

    var buffer = req.body.newbuffer
    buffers.push(buffer)
    res.send("OK")
});

app.get('/', function (req, res) {
    res.send(device)
});

app.listen(3000, function () {
    console.log('Example app listening on port 3000!')
});