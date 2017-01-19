var express = require('express')
var app = express()

var device = "sds"

app.post ('/post', function (req, res) {
    device = req.param('id');
    console.log(device)
    res.send(device)
})

app.get('/', function (req, res) {
    res.send(device)
})

app.listen(3000, function () {
    console.log('Example app listening on port 3000!')
})