
/*
 * GET home page.
 */
var Operator = require('../lib/operator');
var operator = new Operator();

exports.index = function(req, res){
  res.render('index', { title: 'pfunk - index' })
};
exports.rooms = function(req, res){
  res.render('rooms', { title: 'pfunk - ' + req.params.id })
  io.sockets.on('connection', function(socket) {
    socket.join(req.params.id);
    socket.emit('connected', { body: 'listening' });
    socket.on('say', function(msg) {
      io.sockets.in(req.params.id).emit('receive', msg);
    });
  });
};
