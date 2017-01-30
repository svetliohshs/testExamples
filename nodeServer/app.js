var express = require('express');
var app = express();

// Port where we'll run the websocket server
var webSocketsServerPort = 3000;

// websocket and http servers
var webSocketServer = require('websocket').server;
var http = require('http');


/**
 * Global variables
 */
// latest 100 messages
var history = [ ];
// list of currently connected clients (users)
var clients = [ ];



app.listen(webSocketsServerPort, function() {
    console.log((new Date()) + " Server is listening on port " + webSocketsServerPort);
    console.log("dasda");
});

/**
 * WebSocket server
 */
var wsServer = new webSocketServer({
    // WebSocket server is tied to a HTTP server. WebSocket request is just
    // an enhanced HTTP request. For more info http://tools.ietf.org/html/rfc6455#page-6
    httpServer: app
});

// This callback function is called every time someone
// tries to connect to the WebSocket server
wsServer.on('request', function(request) {
    console.log((new Date()) + ' Connection from origin ' + request.origin + '.');

    // // accept connection - you should check 'request.origin' to make sure that
    // // client is connecting from your website
    // // (http://en.wikipedia.org/wiki/Same_origin_policy)
    // var connection = request.accept(null, request.origin); 
    // // we need to know client index to remove them on 'close' event
    // var index = clients.push(connection) - 1;
    // var userName = false;
    // var userColor = false;

    // console.log((new Date()) + ' Connection accepted.');

    // // send back chat history
    // if (history.length > 0) {
    //     connection.sendUTF(JSON.stringify( { type: 'history', data: history} ));
    // }

    // // user sent some message
    // connection.on('message', function(message) {
    //     if (message.type === 'utf8') { // accept only text
    //         if (userName === false) { // first message sent by user is their name
    //             // remember user name
    //             userName = htmlEntities(message.utf8Data);
    //             // get random color and send it back to the user
    //             userColor = colors.shift();
    //             connection.sendUTF(JSON.stringify({ type:'color', data: userColor }));
    //             console.log((new Date()) + ' User is known as: ' + userName
    //                         + ' with ' + userColor + ' color.');

    //         } else { // log and broadcast the message
    //             console.log((new Date()) + ' Received Message from '
    //                         + userName + ': ' + message.utf8Data);
                
    //             // we want to keep history of all sent messages
    //             var obj = {
    //                 time: (new Date()).getTime(),
    //                 text: htmlEntities(message.utf8Data),
    //                 author: userName,
    //                 color: userColor
    //             };
    //             history.push(obj);
    //             history = history.slice(-100);

    //             // broadcast message to all connected clients
    //             var json = JSON.stringify({ type:'message', data: obj });
    //             for (var i=0; i < clients.length; i++) {
    //                 clients[i].sendUTF(json);
    //             }
    //         }
    //     }
    // });

    // // user disconnected
    // connection.on('close', function(connection) {
    //     if (userName !== false && userColor !== false) {
    //         console.log((new Date()) + " Peer "
    //             + connection.remoteAddress + " disconnected.");
    //         // remove user from the list of connected clients
    //         clients.splice(index, 1);
    //         // push back user's color to be reused by another user
    //         colors.push(userColor);
    //     }
    // });

});




// var bodyParser = require('body-parser');
// app.use(bodyParser.json()); // support json encoded bodies
// app.use(bodyParser.urlencoded({ extended: false })); // support encoded bodies


// var device = "sds";
// var buffers = [];

// app.post ('/post', function (req, res) {

//     var buffer = req.body.newbuffer
//     buffers.push(buffer)
//     res.send("OK")
// });

// app.get('/', function (req, res) {
//     res.send(device)
// });

// app.listen(3000, function () {
//     console.log('Example app listening on port 3000!')
// });