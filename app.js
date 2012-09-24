
/**
 * Module dependencies.
 */
var mochiscript = require('mochiscript');

var express = require('express')
  , path = require('path');

var app = module.exports = express.createServer();
var io = require('socket.io').listen(app);
var operator = require('./lib/operator')(io);

// Configuration

app.configure(function(){
  console.log(__dirname);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.set("view options", { pretty: true });
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  app.use(mochiscript.middleware({ 
    src:  "views"
  }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
  app.use(mochiscript.middleware({ 
    src:  path.join(__dirname, '/views'), 
    dest: path.join(__dirname, '/public/javascripts')
  }));
});

// Routes

app.get('/', function (req, res, next){
  res.render('rooms', { title: 'pfunk - ' + req.params.id })
  io.sockets.on('connection', function(socket) {
    socket.join(req.params.id);
    socket.emit('connected', { body: 'listening' });
    socket.on('say', function(msg) {
      io.sockets.in(req.params.id).emit('receive', msg);
    });
  });
});

app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});


