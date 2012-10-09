var Room = require('./room');
var Persister = require('./persister');

export class Operator {
  function initialize(app) {
    this.io = require('socket.io').listen(app);
    this.persister = new Persister();
    this.setupIO(app, this.io);
    this.rooms = {};
    this.idx = 0;
  }

  function persist(options) {
    this.persister.connect(options);
  }

  function addRoom(name) {
    return this.rooms[name] = new Room(name, this.io.sockets, self.persister);
  }

  function setupIO(app, io) {
    io.sockets.on('connection', function(socket) {
      socket.emit('connected', { msg: 'listening' });

      socket.on('join', #(data) { socket.join(data.room); });

      socket.on('say', function(data) {
        var room = self.getRoom(data.room);
        room.say(data);
      });

      socket.on('replay', function(data) {
        var room = self.getRoom(data.room);
        room.replay(new Date(data.from), new Date(data.to), #(err, d) {
          if (d) socket.emit(d.type, d.data);
        });
      });

      socket.on('cmd', #(data) {
        var room   = self.getRoom(data.room);
        data.cmdId = self.idx++;
        room.cmd(data);
      });
    });
  }

  function getRoom(name) {
    return this.rooms[name];
  }
} 
